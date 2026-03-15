# Octopus in a nutshell

## Tutorial First Deployment

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

All is here

https://octopus.com/docs/getting-started
## Tutorial First Runbook


All is here

https://octopus.com/docs/getting-started/first-runbook-run






