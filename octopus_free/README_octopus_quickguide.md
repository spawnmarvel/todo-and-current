# Octopus in a nutshell

## Tutorial First Deployment to windows

1. Project you have made
2. Packages upload if needed
3. Process (steps, files, script etc)
4. Release create
5. Deploy to environment and or target from project dashboard release

Upload zipped beartail example

* Package name must have a version number and no spaces e.g hello-world.1.0.0.zip
Supported formats: NuGet, zip, tar, tar gzip, tar bzip2, jar, war, ear and rar.

Go to project and process

Add step (upload a packet), select beartail, select a tag i.e windows and save.

Now in project and process we have the new steps and the tags.

![process_baretail](https://github.com/spawnmarvel/todo-and-current/blob/main/octopus_free/images/process_baretail.png)

Now create a release and all steps are saved including the new one.

When you click Deploy, Octopus allows you to override the default "deploy to everyone" behavior.

* Go to your Project dashboard and click deploy to on a release (last one for example).

![deploy_to_target](https://github.com/spawnmarvel/todo-and-current/blob/main/octopus_free/images/deploy_to_target.png)

* Add environment dev for example and go all the way down to preview and customization.

* Look for the Exclude Machines or Specific Machines section (usually under "Advanced" or "Targeting").
* Select only the specific machine you want to target.
* Include specific deployment targets (yourvm)
* Octopus will ignore the rest of the environment and only talk to that one VM.
* Now press the release and deploy.

![the target](https://github.com/spawnmarvel/todo-and-current/blob/main/octopus_free/images/the_target.png)

And we are done.

![done](https://github.com/spawnmarvel/todo-and-current/blob/main/octopus_free/images/done.png)

On vmhybrid01.

```ps1
c:\Octopus\Files

03/15/2026  04:00 PM    <DIR>          .
03/15/2026  04:00 PM    <DIR>          ..
03/15/2026  04:00 PM           114,216 baretail@S1.0.0@5763cfa.zip
03/15/2026  04:00 PM           345,984 hello-world@S1.0.0@1f78be6.zip
               2 File(s)        460,200 bytes
               2 Dir(s)  114,685,624,320 bytes free
               
```

## Variables

![variables](https://github.com/spawnmarvel/todo-and-current/blob/main/octopus_free/images/variables_2.png)

Use them in code.

Go to the step that was created in a relase and see it:

![vars](https://github.com/spawnmarvel/todo-and-current/blob/main/octopus_free/images/vars.png)

To create new go to Project variables, add a var and save it.

![f key](https://github.com/spawnmarvel/todo-and-current/blob/main/octopus_free/images/f_key.png)


Go to the step that was created in a relase and edit the inline script.

Create a new release and deploy it to a target.

![var_done](https://github.com/spawnmarvel/todo-and-current/blob/main/octopus_free/images/var_done.png)


```ps1
PS C:\Octopus\Files> hostname
vmhybrid01

cd C:\Octopus\Files\
PS C:\Octopus\Files> dir


    Directory: C:\Octopus\Files


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----         3/15/2026   4:00 PM         114216 baretail@S1.0.0@5763cfa.zip
-a----         3/15/2026   4:00 PM         345984 hello-world@S1.0.0@1f78be6.zip
```

Steps

* Ran a ps1 step on octopus with var
* Deployed a packet x 2 to vmhybrid01

![steps_4](https://github.com/spawnmarvel/todo-and-current/blob/main/octopus_free/images/steps_4.png)

All is here

https://octopus.com/docs/getting-started

## Tutorial First Deployment to linux

Add new deployment target.

![details manual](https://github.com/spawnmarvel/todo-and-current/blob/main/octopus_free/images/details_m.png)

Linux Tentacle

If you want to deploy software to Linux servers without using SSH, you need to install Tentacle, a lightweight agent service, on your Linux servers so they can communicate with the Octopus Server.

Before you can configure a Linux Tentacle, the Linux server must meet the requirements and the following additional requirements:

Octopus Server 2019.8.3 or newer
Linux Tentacle is a .NET application distributed as a self-contained deployment. On most Linux distributions it will just work, but be aware that you will need to install some prerequisites.


We are using Octopus.2026.1.11242-x64.msi for server installtion.


### Installing Tentacle on linux

Login ssh

Check ufw
```bash
sudo ufw status
Status: inactive
```

Create NSG with inbound 10933

Login and sudo nano install_tentacle.sh

```bash
#!/bin/bash
echo "Tea anyone?"
sudo apt update && sudo apt install --no-install-recommends gnupg curl ca-certificates apt-transport-https && \
sudo install -m 0755 -d /etc/apt/keyrings && \
curl -fsSL https://apt.octopus.com/public.key | sudo gpg --dearmor -o /etc/apt/keyrings/octopus.gpg && \
sudo chmod a+r /etc/apt/keyrings/octopus.gpg && \
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/octopus.gpg] https://apt.octopus.com/ \
  stable main" | \
  sudo tee /etc/apt/sources.list.d/octopus.list > /dev/null && \
sudo apt update && sudo apt install tentacle

```
Run it
```bash
Run it bash install_tentacle.sh
```

Setting up a Tentacle instanceBookmark
Many instances of Tentacle can be configured on a single machine. To configure an instance run the following setup script:

```bash
/opt/octopus/tentacle/configure-tentacle.sh
```

Follow the steps in cmd

```txt
imsdal@vmchaos09:~$ /opt/octopus/tentacle/configure-tentacle.sh
Name of Tentacle instance (default Tentacle):vmchaos09
What kind of Tentacle would you like to configure: 1) Listening or 2) Polling (default 1): 1
Where would you like Tentacle to store configuration, logs, and working files? (/etc/octopus):
Where would you like Tentacle to install applications to? (/home/Octopus/Applications):
Enter the port that this Tentacle will listen on (10933):
Should the Tentacle use a proxy to communicate with Octopus? (y/N): N
Enter the thumbprint of the Octopus Server: C6210Fxxxxxxxxxxxxxxxxxxxx

```
Log

```log
Press enter to continue...
Creating empty configuration file: /etc/octopus/vmchaos09/tentacle-vmchaos09.config
Saving instance: vmchaos09
Setting home directory to: /etc/octopus/vmchaos09
A new certificate has been generated and installed. Thumbprint:
3C4D84xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
These changes require a restart of the Tentacle.
Removing all trusted Octopus Servers...
Application directory set to: /home/Octopus/Applications
Services listen port: 10933
Tentacle will listen on a TCP port
These changes require a restart of the Tentacle.
Adding 1 trusted Octopus Servers
These changes require a restart of the Tentacle.
Service installed: vmchaos09
Service started: vmchaos09

Tentacle instance 'vmchaos09' is now installed

```



Now continue to deployments targets again, enter manual.

* Name
* Environment
* Tags, create a tag for the vm also
* Thumbprint from the install, paste into octopus manager
* Tentacle URL
* Connect to this tentacle directly

Hit save and do a health check.



![target_linux](https://github.com/spawnmarvel/todo-and-current/blob/main/octopus_free/images/target_linux.png)


https://octopus.com/docs/infrastructure/deployment-targets/tentacle/linux#installing-tentacle


https://octopus.com/docs/infrastructure/deployment-targets/tentacle/linux


## Tutorial First Runbook

Deployments are just one piece of the deployment puzzle. You also have to manage day-1 and day-2 operations. Octopus Runbooks lets you automate these routine and emergency operations tasks, giving you one platform for DevOps automation.

A runbook is a set of instructions that help you consistently carry out a task, whether it’s routine maintenance or responding to an incident. Octopus provides the platform for your runbooks just as it does for your deployments.

Runbooks automate routine maintenance and emergency operations tasks, like:

* Infrastructure provisioning
* Database management
* Website failover and restoration

https://octopus.com/docs/runbooks


All is here

https://octopus.com/docs/getting-started/first-runbook-run






