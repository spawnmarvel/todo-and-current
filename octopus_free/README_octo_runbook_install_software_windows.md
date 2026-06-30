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