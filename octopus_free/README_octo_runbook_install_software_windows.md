# Octopus deploy runbooks for install windows applications


## RabbitMQ install runbook

Upload packet but zip first

* rabbitmq-server-4.3.2.exe, rabbitmq-server-4.3.2.zip
* otp_win64_27.3.exe

Uploaded to octopus


![packets](https://github.com/spawnmarvel/todo-and-current/blob/main/octopus_free/images/packets_rmq.png)


vm target, vmtargetnode03.

### Step 1: Create a Runbook Step using the Built-In "Transfer A Package" Step

Instead of writing code, you can use Octopus's built-in file transfer system:

Add a new step to your Runbook and search for Deploy a Package.

Name the step Transfer Installers to VM.

Add both packages from your library: otp_win64_27 and rabbitmq-server-4.

Under Destination directory, choose where you want them dropped on the VM (e.g., C:\DroppedInstallers).

Octopus will handle the safe, authenticated transfer over the Tentacle protocol automatically.


![packets uploaded](https://github.com/spawnmarvel/todo-and-current/blob/main/octopus_free/images/packets_rmq_uploaded.png)