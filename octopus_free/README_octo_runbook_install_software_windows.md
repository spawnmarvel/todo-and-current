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
# Version: 1.1.0
# Description: Idempotently executes the Erlang setup installer only if no existing installation directory is discovered.

$programFiles = [Environment]::GetFolderPath("ProgramFiles")
$existingErl = Get-ChildItem -Path $programFiles -Directory -Filter "*Erlang*" -ErrorAction SilentlyContinue | Select-Object -First 1
if (-not $existingErl) {
    $existingErl = Get-ChildItem -Path $programFiles -Directory -Filter "erl-*" -ErrorAction SilentlyContinue | Select-Object -First 1
}

if ($existingErl -and (Test-Path "$($existingErl.FullName)\bin\erl.exe")) {
    Write-Host "Idempotency Check: Erlang binaries detected at '$($existingErl.FullName)'. Skipping installer execution."
    exit 0
}

Write-Host "Erlang execution folder not detected. Proceeding with installation..."
$stageDir = "C:\Octopus_Stage\Erlang"
$installer = Get-ChildItem -Path $stageDir -Filter "otp_win64_*.exe" -Recurse | Select-Object -First 1

if ($installer) {
    Write-Host "Found Erlang installer at: $($installer.FullName)"
    Write-Host "Running silent installation..."
    
    $process = Start-Process -FilePath $installer.FullName -ArgumentList "/S" -Wait -NoNewWindow -PassThru
    
    if ($process.ExitCode -eq 0) {
        Write-Host "Erlang installer completed successfully."
    } else {
        Write-Warning "Erlang installer exited with code: $($process.ExitCode)"
    }
} else {
    Write-Error "Erlang installer executable not found inside $stageDir."
    exit 1
}
```


### Step 3: Set ERLANG_HOME (Idempotent via Machine Target)

This step checks your machine's environment target path using the proven method. If ERLANG_HOME matches the active installation directory path, it skips setting it again.

Step Type: Run a Script

Script Type: PowerShell

```ps1
# Version: 1.4.2
# Description: Idempotently configures ERLANG_HOME and PATH using the proven .NET Machine Target engine and signals the OS for instant notification without a reboot.

# 1. Locate the path where Erlang was dropped
$programFiles = [Environment]::GetFolderPath("ProgramFiles")
$erlFolder = Get-ChildItem -Path $programFiles -Directory -Filter "*Erlang*" -ErrorAction SilentlyContinue | Select-Object -First 1

if (-not $erlFolder) {
    $erlFolder = Get-ChildItem -Path $programFiles -Directory -Filter "erl-*" -ErrorAction SilentlyContinue | Select-Object -First 1
}

if ($erlFolder) {
    $erlangHomePath = $erlFolder.FullName.TrimEnd('\')
    $variableChanged = $false
    
    # 2. Advanced Idempotency Check using Proven Machine Target Evaluation
    $existingHome = [Environment]::GetEnvironmentVariable("ERLANG_HOME", [EnvironmentVariableTarget]::Machine)
    
    if ($existingHome -eq $erlangHomePath -and (Test-Path $existingHome)) {
        Write-Host "Idempotency Check: ERLANG_HOME is already configured to a valid path at '$existingHome'."
    } else {
        if (-not $existingHome) {
            Write-Warning "ERLANG_HOME was missing from the Machine layer (possibly removed manually). Restoring..."
        } elseif (-not (Test-Path $existingHome)) {
            Write-Warning "ERLANG_HOME was pointing to an invalid or missing path '$existingHome'. Updating..."
        }
        
        Write-Host "Asserting Erlang System Environment Variable to: $erlangHomePath"
        [Environment]::SetEnvironmentVariable("ERLANG_HOME", $erlangHomePath, [EnvironmentVariableTarget]::Machine)
        $variableChanged = $true
    }
    
    # 3. Idempotently append to Machine Path registry string using the Proven Engine
    $erlangBinPath = "$erlangHomePath\bin"
    $currentMachinePath = [Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::Machine)
    
    if ($currentMachinePath -notlike "*$erlangBinPath*") {
        Write-Host "Appending Erlang bin folder to system-wide Machine PATH..."
        $newMachinePath = "$currentMachinePath;$erlangBinPath"
        [Environment]::SetEnvironmentVariable("Path", $newMachinePath, [EnvironmentVariableTarget]::Machine)
        $variableChanged = $true
    } else {
        Write-Host "Idempotency Check: Erlang bin directory path is already included inside the Machine PATH environment map."
    }

    # 4. If changes were made, notify the OS globally so you do not have to reboot
    if ($variableChanged) {
        Write-Host "Changes detected. Sending system broadcast (WM_SETTINGCHANGE) to refresh environment blocks instantly..."
        try {
            $signature = '[DllImport("user32.dll", SetLastError = true, CharSet = CharSet.Auto)] public static extern IntPtr SendMessageTimeout(IntPtr hWnd, uint Msg, IntPtr wParam, string lParam, uint fuFlags, uint uTimeout, out IntPtr lpdwResult);'
            $type = Add-Type -MemberDefinition $signature -Name "Win32Utils" -Namespace "OctopusEnvironmentRefresh" -PassThru
            $result = [IntPtr]::Zero
            # Send message to HWND_BROADCAST (0xffff) targeting "Environment"
            $type::SendMessageTimeout([IntPtr]0xffff, 0x001A, [IntPtr]::Zero, "Environment", 0x0002, 4000, [ref]$result) | Out-Null
            Write-Host "System environment broadcast completed successfully."
        } catch {
            Write-Warning "Failed to broadcast environment update signal: $_"
        }
    }

    Write-Host "Erlang environment verification phase completed successfully."
} else {
    Write-Error "Critical Failure: Could not find the Erlang installation directory inside Program Files."
    exit 1
}
```



### What is up with cmd set?

Check that we can run set and view environment vars also

https://serverfault.com/questions/8855/how-do-you-add-a-windows-environment-variable-without-rebooting

https://stackoverflow.com/questions/12323621/windows-x64-rabbitmq-install-error-with-erlang-environment-var-erlang-home

### Need a boot yes

### Step 5: Pre-Configure RabbitMQ Environment (Idempotent)

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

This step reads ERLANG_HOME directly from the registry location seen in image.png to ensure the installation path is recognized, then checks if the Windows service already exists before trying to run the installer.

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

