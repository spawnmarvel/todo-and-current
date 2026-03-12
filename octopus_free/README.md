# Octopus deploy

## Octopus server free

https://octopus.com/pricing/overview

* Octopus Free
* Register with work mail
* Hosting, Server (installed on your server)
* Organization, SocratesINC



![free](https://github.com/spawnmarvel/todo-and-current/blob/main/octopus_free/images/free.png)

## Install Octopus Server

Go to my account and control center

![org](https://github.com/spawnmarvel/todo-and-current/blob/main/octopus_free/images/org.png)

Hi Aspen,

Thanks for signing up for your free Octopus Server account.

To get started:

* Copy your license key from your Octopus account.
* Download and install Octopus Server.
* Run the setup wizard, and copy and paste your license key when prompted. 

https://octopus.com/docs/installation

1. Download Octopus Server
Click the link below to download the 64-bit MSI installer for Windows.
Download Octopus

* C:\giti2026\Octopus-download\Octopus.2026.1.11242-x64.msi

* Start SQL Server (SQLEXPRESS) windows service, it is manual now.
* Login to HOSTNAME\SQLEXPRESS
* Default windows update

2. Run the setup wizard
Copy and paste your license key when prompted.
Read the guide

3. Your first deployment
Start using your new Octopus instance by doing your first deployment.
Follow the tutorial

Octopus ComponentsBookmark

There are three components to an Octopus Deploy instance:

* Octopus Server Service This service serves user traffic and orchestrates deployments. Octopus Deploy supports running the service on Windows Server or as a Linux Container.
* SQL Server Database Most data used by the Octopus Server nodes is stored in this database. SQL Server 2016+ or Azure SQL is required.
* Files or BLOB Storage Some larger files - like packages, artifacts, and deployment task logs - aren’t suitable to be stored in the database and are stored on the file system instead. This can be a local folder, a network file share, or a cloud provider’s storage.

All inbound traffic to Octopus Deploy is via:

* HTTP/HTTPS (ports 80/443)
* Polling tentacles (port 10943)
* gRPC (port 8443)

## Install Octopus as a Windows Service


![msi](https://github.com/spawnmarvel/todo-and-current/blob/main/octopus_free/images/msi.png)

* Download the Octopus installer.
* Start the Octopus Installer, click Next, accept the Terms in the License Agreement and click Next.
* Accept the default Destination Folder or choose a different location and click Next.
* Click Install, and give the app permission to make changes to your device.
* Click Finish to exit the installation wizard and launch the Getting started wizard to configure your Octopus Server.

* Click Get started… and either enter your details to start a free trial of Octopus Deploy or enter your license key and click Next.

![key](https://github.com/spawnmarvel/todo-and-current/blob/main/octopus_free/images/key.png)

* Accept the default Home Directory or enter a location of your choice and click Next, C:\Octopus
* Decide whether to use a Local System Account or a Custom Domain Account.

![sys acc](https://github.com/spawnmarvel/todo-and-current/blob/main/octopus_free/images/sys_acc.png)

Create a user in the database, sql server express

```sql
USE [master];
GO

-- 1. Create the Login (Server-level)
IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = 'OctopusUser')
BEGIN
    CREATE LOGIN [OctopusUser] 
    WITH PASSWORD = 'YourStrongPassword123!', 
    CHECK_POLICY = ON;
END
GO

-- 2. Grant permission to CREATE new databases
-- This allows the Octopus Installer to create the "OctopusDeploy" DB
ALTER SERVER ROLE [dbcreator] ADD MEMBER [OctopusUser];
GO

-- 3. Grant permission to view server state (Recommended for Octopus health checks)
GRANT VIEW SERVER STATE TO [OctopusUser];
GO
```


Go to server->properties and select both auth methods, SQL Server and Windows Authentication mode.

![auth_both](https://github.com/spawnmarvel/todo-and-current/blob/main/octopus_free/images/auth_both.png)


* Open services.msc.

* Find SQL Server (SQLEXPRESS).

* Right-click and select Restart.

On the Database page, click the drop-down arrow in the Server Name field to detect the SQL Server Database. Octopus will create the database for you which is the recommended process; however, you can also create your own database.

* Enter a name for the database, and click Next and OK to create the database.

![db_create](https://github.com/spawnmarvel/todo-and-current/blob/main/octopus_free/images/db_create.png)

Next

![v_dir](https://github.com/spawnmarvel/todo-and-current/blob/main/octopus_free/images/v_dir.png)

Next

![user](https://github.com/spawnmarvel/todo-and-current/blob/main/octopus_free/images/user.png)

Install

![install](https://github.com/spawnmarvel/todo-and-current/blob/main/octopus_free/images/install.png)

Web server

![running](https://github.com/spawnmarvel/todo-and-current/blob/main/octopus_free/images/running.png)

Change to HTTPS

From http://localhost:80/ to 443

* Open Octopus Manager: Search your Start menu for "Octopus Manager" and run it as Administrator.

* Locate the Web Portal settings: In the sidebar, select your Octopus Server instance.

* Configure HTTPS: Look for the "Web Portal" or "Listen Prefixes" section.

Add/Edit Prefix:

* Change the address from http://localhost:80/ to https://hostname:443/ (or your preferred port).

* It will then ask you to Select a Certificate.

* Choose generate self signed for this session

Visit

https://localhost/


![cert](https://github.com/spawnmarvel/todo-and-current/blob/main/octopus_free/images/cert.png)

New settings on Octopus Manager

![new_settings](https://github.com/spawnmarvel/todo-and-current/blob/main/octopus_free/images/new_settings.png)


## Octopus deploy free edition

* All core features: You get the full deployment engine, variable management, and step templates without any "lite" version limitations.

* 10 projects: You can create up to 10 distinct deployment pipelines (e.g., one for MySQL, one for Zabbix, one for Apache).

* 10 tenants: Allows you to deploy the same project to multiple "customers" or "silos" with isolated configurations.

* 10 machines: You can register up to 10 deployment targets (like your Linux VMs or Windows servers) across your environments.

* 1 space: You have one isolated working area to manage your team's projects, variables, and infrastructure. Since you only have 1 Space, everyone who has access to that space will see all the projects and environments.

* 10 users: Up to 10 individual teammates can have their own logins to manage or view deployments.

* 5 concurrent tasks: Octopus can run up to 5 things at once (e.g., deploying to 5 servers simultaneously or running 5 different projects).

* 1 instance: You can install and run one single Octopus Server installation.

* 1 node: Your Octopus Server runs on a single machine rather than a "High Availability" cluster of multiple servers.

* Runbook automation: A feature for automating routine tasks like DB backups or service restarts that aren't part of a code release.

* Environment promotion: The "lifecycle" logic that lets you move a proven release from Dev to Test and finally to Production.

* SSO (Single Sign-On): Connects Octopus to your company's login system (like Active Directory or Google) so you don't need separate passwords.

* RBAC (Role-Based Access Control): Allows you to set specific permissions for who can "View," "Edit," or "Deploy" to different environments.

* Community support: Access to the community forums and public documentation for help rather than a dedicated 24/7 support engineer.

## Tutorial (Push mode only) and concepts

Your first deployment
Start using your new Octopus instance by doing your first deployment.
Follow the tutorial

* Open services.msc.

* Find SQL Server (SQLEXPRESS).

* Right-click and select start (is manual)

https://ber-0803

Files

```ps1
cd C:\Octopus
ls -Name

# Artifacts
# Logs
# OctopusServer
# Packages
# SharedPackageCache
# TaskLogs
# Telemetry
# OctopusServer.config
```

Tutorial

https://octopus.com/docs/getting-started


### Projects, environments, and releases

Projects are the applications we deploy.

Environments are where we deploy the applications. In this case, Dev, Test and Production.

A Release is a bundle of all the things needed to deploy a specific version of an application. This might include:

* The container images or packages (artifacts produced from a CI build)
* The associated configuration and variables needed to configure the release for each environment
* A snapshot of the process that will be used to deploy the release, as the process may change in future releases
* Details on Jira tickets and Git commits that went into the release


### Deployment process

Inside each project, you’ll configure a Deployment Process. The deployment process is like the recipe for deploying the project - the steps that will be run.

Each step contains a specific action (or set of actions) that is executed as part of the deployment process each time your software is deployed. After the initial setup, your deployment process shouldn’t change between deployments even though the software being deployed will change as part of the development process.

### Variables

For instance, your test environment shouldn’t have access to your production database. Using variables, you can specify a different database for each environment, ensuring your production data won’t be impacted by codes changes that are still in review.

### Infrastructure

Octopus Deploy organizes your deployment targets (the machines and services you deploy software to) into groups called environments. Typical environments are Dev, Test, and Production.

### Lifecycles

When you define a project, you also select a lifecycle. The lifecycle defines the promotion rules around how releases of the project are deployed between environments, which projects are deployed to which environments.

### Runbook automation

A deployment is only one phase in the life of an application. There are many other tasks that are performed to keep an application operating - often called “Day 2”.

Octopus Runbooks live inside a Project, and can be used to automate routine maintenance and emergency operations tasks like infrastructure provisioning, database management, and website failover and restoration.

### Tenants

Tenants in Octopus allow you to easily create customer specific deployment pipelines without duplicating project configuration.

If a project uses tenants, a release can be deployed to all tenants, a single tenant, or a group of tenants using tags.

### Spaces

If you’re a large organization with lots of teams working in Octopus, you can use the Spaces feature to provide each of your teams with a space for the projects, environments, and infrastructure they work with, while keeping other teams’ assets separate in their own spaces.

### First Deployment

Project

1. Log in to your Octopus instance and click New Project.
2. Give your project a descriptive name, for example, Hello world deployment.
3. For this example, keep the default Octopus option selected.
4. Leave the rest as is and click Create Project.

![project](https://github.com/spawnmarvel/todo-and-current/blob/main/octopus_free/images/project.png)

Environments

5. Keep the default environments and click Create Environments.

![env](https://github.com/spawnmarvel/todo-and-current/blob/main/octopus_free/images/env.png)

Create deployment process

The next step is creating your deployment process. This is where you define the steps that Octopus uses to deploy your software.












