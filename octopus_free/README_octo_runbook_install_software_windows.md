# Octopus deploy runbooks for install windows applications


## RabbitMQ install runbook

Upload packet but zip first

* rabbitmq-server-4.3.2.exe, rabbitmq-server-4.3.2.zip
* otp_win64_27.3.exe

Uploaded to octopus


![packets](https://github.com/spawnmarvel/todo-and-current/blob/main/octopus_free/images/packets_rmq.png)


vm target, vmtargetnode03.

### Step 0: Create a Runbook Step using the Built-In "Transfer A Package" Step

Instead of writing code, you can use Octopus's built-in file transfer system:

Add a new step to your Runbook and search for Deploy a Package.

Name the step Transfer Installers to VM.

Add both packages from your library: otp_win64_27 and rabbitmq-server-4.

Under Destination directory, choose where you want them dropped on the VM (e.g., C:\DroppedInstallers).

Octopus will handle the safe, authenticated transfer over the Tentacle protocol automatically.


![packets uploaded](https://github.com/spawnmarvel/todo-and-current/blob/main/octopus_free/images/packets_rmq_uploaded.png)



### Step 1: Extract and Stage Packets from C:\Octopus\Files

Add this script as Step 1 of your Runbook. It will look inside C:\Octopus\Files\, locate the zip files matching your pattern from image, and expand them into a temporary installation folder.

Step Name: Unpack Installation Packets

Script Type: PowerShell

```ps1
# Version: 1.0.0
# Description: Extracts the exact zip packets found in C:\Octopus\Files\ as shown in image_64c9c4.png

$sourceDir = "C:\Octopus\Files"
$destinationStage = "C:\Octopus_Stage"

# Create clean staging directory if it doesn't exist
if (-not (Test-Path $destinationStage)) {
    New-Item -ItemType Directory -Force -Path $destinationStage | Out-Null
}

# 1. Find and Extract Erlang Zip
$erlangZip = Get-ChildItem -Path $sourceDir -Filter "otp_win64_27*.zip" | Select-Object -First 1
if ($erlangZip) {
    Write-Host "Found Erlang package: $($erlangZip.Name)"
    Write-Host "Extracting to $destinationStage..."
    Expand-Archive -Path $erlangZip.FullName -DestinationPath "$destinationStage\Erlang" -Force
} else {
    Write-Error "Could not find the Erlang zip file in $sourceDir"
    exit 1
}

# 2. Find and Extract RabbitMQ Zip
$rabbitZip = Get-ChildItem -Path $sourceDir -Filter "rabbitmq-server-4*.zip" | Select-Object -First 1
if ($rabbitZip) {
    Write-Host "Found RabbitMQ package: $($rabbitZip.Name)"
    Write-Host "Extracting to $destinationStage..."
    Expand-Archive -Path $rabbitZip.FullName -DestinationPath "$destinationStage\RabbitMQ" -Force
} else {
    Write-Error "Could not find the RabbitMQ zip file in $sourceDir"
    exit 1
}

Write-Host "Packets extracted and prepared in $destinationStage."
```

![packets stage](https://github.com/spawnmarvel/todo-and-current/blob/main/octopus_free/images/packets_rmq_stage.png)


### Step 2: Install Erlang & Verify ERLANG_HOME (Idempotent)

Step Type: Run a Script

Package Reference: None (Reads directly from your local staging directory)

```ps1
# Version: 3.8.0
# Description: Installs Erlang, registers ERLANG_HOME globally, and broadcasts a system update to refresh new CMD sessions.

# --- IDEMPOTENCY CHECK: Is ERLANG_HOME already valid? ---
$existingHome = [Environment]::GetEnvironmentVariable("ERLANG_HOME", [EnvironmentVariableTarget]::Machine)

if ($existingHome -and (Test-Path "$existingHome\bin\erl.exe")) {
    Write-Host "Idempotency Notice: ERLANG_HOME is already set to '$existingHome' and erl.exe exists."
    Write-Host "Erlang is already installed and configured. Skipping installation steps entirely."
    exit 0
}

Write-Host "Erlang is not fully installed or configured. Proceeding with installation sequence..."

$stageDir = "C:\Octopus_Stage\Erlang"
$installer = Get-ChildItem -Path $stageDir -Filter "otp_win64_*.exe" -Recurse | Select-Object -First 1

if ($installer) {
    Write-Host "Found Erlang installer at: $($installer.FullName)"
    Write-Host "Running silent installation..."
    
    $process = Start-Process -FilePath $installer.FullName -ArgumentList "/S" -Wait -NoNewWindow -PassThru
    
    if ($process.ExitCode -eq 0) {
        Write-Host "Erlang installer finished successfully."
    } else {
        Write-Warning "Erlang installer exited with code: $($process.ExitCode)"
    }
    
    # --- DYNAMIC LOCATION PATH FINDER ---
    $erlangHomePath = $null

    # Method 1: Check Windows Registry
    $regPaths = @(
        "HKLM:\SOFTWARE\Ericsson\Erlang",
        "HKLM:\SOFTWARE\Wow6432Node\Ericsson\Erlang"
    )

    foreach ($regPath in $regPaths) {
        if (Test-Path $regPath) {
            $subKeys = Get-ChildItem -Path $regPath -ErrorAction SilentlyContinue
            foreach ($subKey in $subKeys) {
                $pathVal = (Get-ItemProperty -Path $subKey.PsPath -Name "(default)" -ErrorAction SilentlyContinue)."(default)"
                if ($pathVal -and (Test-Path $pathVal)) {
                    $erlangHomePath = $pathVal
                    Write-Host "Found Erlang installation path via Registry: $pathVal"
                    break
                }
            }
        }
        if ($erlangHomePath) { break }
    }

    # Method 2: Fallback Broad Directory Search
    if (-not $erlangHomePath) {
        Write-Warning "Registry path not found. Falling back to multi-directory scan..."
        $searchPaths = @(
            [Environment]::GetFolderPath("ProgramFiles"),
            ${env:ProgramFiles(x86)}
        )
        
        foreach ($targetBase in $searchPaths) {
            if ($targetBase) {
                $erlFolder = Get-ChildItem -Path $targetBase -Directory -Filter "*Erlang*" -ErrorAction SilentlyContinue | Select-Object -First 1
                if (-not $erlFolder) {
                    $erlFolder = Get-ChildItem -Path $targetBase -Directory -Filter "erl-*" -ErrorAction SilentlyContinue | Select-Object -First 1
                }
                
                if ($erlFolder) {
                    $erlangHomePath = $erlFolder.FullName
                    Write-Host "Found Erlang installation path via Fallback Scan: $erlangHomePath"
                    break
                }
            }
        }
    }

    # --- SET ENVIRONMENT VARIABLES & BROADCAST SYSTEM REFRESH ---
    if ($erlangHomePath) {
        # 1. Update ERLANG_HOME permanently at Machine Layer
        Write-Host "Setting system-wide environment variable ERLANG_HOME to: $erlangHomePath"
        [Environment]::SetEnvironmentVariable("ERLANG_HOME", $erlangHomePath, [EnvironmentVariableTarget]::Machine)
        
        # 2. Update Machine PATH permanently
        $erlangBinPath = "$erlangHomePath\bin"
        $currentMachinePath = [Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::Machine)
        
        if ($currentMachinePath -notlike "*$erlangBinPath*") {
            Write-Host "Appending Erlang bin folder to system-wide Machine PATH variable..."
            $newMachinePath = "$currentMachinePath;$erlangBinPath"
            [Environment]::SetEnvironmentVariable("Path", $newMachinePath, [EnvironmentVariableTarget]::Machine)
        }

        # 3. Native Win32 API Compilation to Broadcast Environment Refresh Message
        Write-Host "Broadcasting WM_SETTINGCHANGE message to refresh Explorer Shell environment..."
        try {
            $Signature = @'
[DllImport("user32.dll", SetLastError = true, CharSet = CharSet.Auto)]
public static extern IntPtr SendMessageTimeout(
    IntPtr hWnd, uint Msg, IntPtr wParam, string lParam, 
    uint fuFlags, uint uTimeout, out IntPtr lpdwResult);
'@
            $Win32API = Add-Type -MemberDefinition $Signature -Name "Win32SendMessage" -Namespace "Win32API" -PassThru
            
            $HWND_BROADCAST = [IntPtr]0xffff
            $WM_SETTINGCHANGE = 0x001A
            $SMTO_ABORTIFHUNG = 0x0002
            $result = [IntPtr]::Zero
            
            $Win32API::SendMessageTimeout($HWND_BROADCAST, $WM_SETTINGCHANGE, [IntPtr]::Zero, "Environment", $SMTO_ABORTIFHUNG, 5000, [ref]$result) | Out-Null
            Write-Host "System environment refresh broadcast completed."
        } catch {
            Write-Warning "Could not send environment refresh broadcast: $_"
        }

        # Verification block against stability
        if (Test-Path "$erlangHomePath\bin\erl.exe") {
            Write-Host "Verification Success: ERLANG_HOME variable valid and active."
        } else {
            Write-Error "Verification Failure: ERLANG_HOME path set to '$erlangHomePath' but 'bin\erl.exe' is missing."
            exit 1
        }
    } else {
        Write-Error "Critical Failure: Unable to locate the Erlang installation path via Registry or File System scan."
        exit 1
    }
} else {
    Write-Error "Erlang installer executable not found inside $stageDir."
    exit 1
}
```

It is idempotent


![install erl](https://github.com/spawnmarvel/todo-and-current/blob/main/octopus_free/images/install_erl.png)


### Step 3: Pre-Configure RabbitMQ Environment (Idempotent)

This step creates your custom data directories and registers the RabbitMQ base and configuration paths. If the configuration files already exist, it will leave them untouched.

Step Type: Run a Script

Package Reference: None



```ps1
# Version: 1.2.0
# Description: Idempotently creates RabbitMQ base/config structures and sets environment variables.

$rabbitBase = "C:\RabbitMQ_Base"
$configDir = "$rabbitBase\config"
$configFile = "$configDir\rabbitmq.conf"
$advancedConfigFile = "$configDir\advanced.config"

# 1. Idempotent Directory Creation
if (-not (Test-Path $configDir)) {
    Write-Host "Creating RabbitMQ Base and Config directories..."
    New-Item -ItemType Directory -Force -Path $configDir | Out-Null
} else {
    Write-Host "Idempotency Check: Configuration directories already exist."
}

# 2. Idempotent Config Stub Dropping
if (-not (Test-Path $configFile)) {
    Write-Host "Creating base rabbitmq.conf file..."
    New-Item -ItemType File -Path $configFile -Force | Out-Null
    Set-Content -Path $configFile -Value "listeners.tcp.default = 5672"
}

if (-not (Test-Path $advancedConfigFile)) {
    Write-Host "Creating advanced.config file..."
    New-Item -ItemType File -Path $advancedConfigFile -Force | Out-Null
    Set-Content -Path $advancedConfigFile -Value "[]."
}

# 3. Set Environment Variables at Machine Target
Write-Host "Asserting RabbitMQ System Environment Variables..."
[Environment]::SetEnvironmentVariable("RABBITMQ_BASE", $rabbitBase, [EnvironmentVariableTarget]::Machine)
[Environment]::SetEnvironmentVariable("RABBITMQ_CONFIG_FILE", $configFile, [EnvironmentVariableTarget]::Machine)
[Environment]::SetEnvironmentVariable("RABBITMQ_ADVANCED_CONFIG_FILE", $advancedConfigFile, [EnvironmentVariableTarget]::Machine)

Write-Host "Pre-configuration checks completed successfully."
```


![pre rmq](https://github.com/spawnmarvel/todo-and-current/blob/main/octopus_free/images/pre_rmq.png)



### Step 4: Install RabbitMQ Server (Idempotent)

This step reads ERLANG_HOME directly from the registry location seen in image_654259.png to ensure the installation path is recognized, then checks if the Windows service already exists before trying to run the installer.

Step Type: Run a Script

Package Reference: None (Reads from C:\Octopus_Stage\RabbitMQ)

```ps1
# Version: 3.3.0
# Description: Installs RabbitMQ silently only if the 'RabbitMQ' service is not already registered.

# --- IDEMPOTENCY CHECK ---
$existingService = Get-Service -Name "RabbitMQ" -ErrorAction SilentlyContinue

if ($existingService) {
    Write-Host "Idempotency Notice: The 'RabbitMQ' Windows service is already registered."
    Write-Host "Skipping installation phase."
    exit 0
}

# Force loading ERLANG_HOME from the machine layer to guarantee the installer sees it
$machineErlangHome = [Environment]::GetEnvironmentVariable("ERLANG_HOME", [EnvironmentVariableTarget]::Machine)
if (-not $machineErlangHome) {
    Write-Error "Critical Prerequisite Missing: ERLANG_HOME could not be resolved from the system registry."
    exit 1
}
$env:ERLANG_HOME = $machineErlangHome

# Locate installer from Step 1 unpack folder
$stageDir = "C:\Octopus_Stage\RabbitMQ"
$installer = Get-ChildItem -Path $stageDir -Filter "rabbitmq-server-*.exe" -Recurse | Select-Object -First 1

if ($installer) {
    Write-Host "Found RabbitMQ installer at: $($installer.FullName)"
    Write-Host "Executing silent installation sequence..."
    
    $process = Start-Process -FilePath $installer.FullName -ArgumentList "/S" -Wait -NoNewWindow -PassThru
    
    if ($process.ExitCode -eq 0) {
        Write-Host "RabbitMQ installer executed successfully."
    } else {
        Write-Warning "RabbitMQ installer returned an unexpected exit code: $($process.ExitCode)"
    }
} else {
    Write-Error "RabbitMQ installer executable not found inside $stageDir."
    exit 1
}
```

