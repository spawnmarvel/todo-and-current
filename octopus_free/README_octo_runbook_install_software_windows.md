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


### Step 2: Install Erlang & Verify ERLANG_HOME

Step Type: Run a Script

Package Reference: None (Reads directly from your local staging directory)

```ps1
# Version: 3.5.0
# Description: Installs Erlang only if missing, sets ERLANG_HOME if not defined, and runs verification checks.

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
                    Write-Host "Found Erlang installation path via Registry: $erlangHomePath"
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

    # --- SET AND VERIFY ENVIRONMENT VARIABLE ---
    if ($erlangHomePath) {
        Write-Host "Setting system-wide environment variable ERLANG_HOME to: $erlangHomePath"
        [Environment]::SetEnvironmentVariable("ERLANG_HOME", $erlangHomePath, [EnvironmentVariableTarget]::Machine)
        
        # Verification
        $verifiedHome = [Environment]::GetEnvironmentVariable("ERLANG_HOME", [EnvironmentVariableTarget]::Machine)
        if ($verifiedHome -and (Test-Path "$verifiedHome\bin\erl.exe")) {
            Write-Host "Verification Success: ERLANG_HOME variable valid and erl.exe detected."
        } else {
            Write-Error "Verification Failure: ERLANG_HOME path set to '$verifiedHome' but 'bin\erl.exe' is missing."
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