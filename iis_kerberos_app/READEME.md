# A aspx app in iis running kerberos


To set up a Kerberos-authenticated IIS application, you need to coordinate the Active Directory service account, the IIS configuration, and the application code

## 1. The ASPX Web Application

* C:\inetpub\kerbtest
* default.aspx
```cs
<%-- Version 1.0.0 --%>
<%@ Page Language="C#" %>
<!DOCTYPE html>
<html>
<head>
    <title>Kerberos Auth Test</title>
</head>
<body>
    <h2>Authentication Details</h2>
    <p><b>User Identity:</b> <%= User.Identity.Name %></p>
    <p><b>Auth Type:</b> <%= User.Identity.AuthenticationType %></p>
    <p><b>App Pool Identity:</b> <%= System.Security.Principal.WindowsIdentity.GetCurrent().Name %></p>
</body>
</html>
```

![app](https://github.com/spawnmarvel/todo-and-current/blob/main/iis_kerberos_app/images/app.png)

## 2. Active Directory Configuration (The SPN)


For Kerberos to work, the Service Principal Name (SPN) must be registered to the service account f_iis_kerb. Without this, IIS will fail back to NTLM.

* Run these commands in an elevated command prompt on a Domain Controller or a machine with RSAT:

```ps1
# Set the SPN for the FQDN: 
setspn -S HTTP/vmhybrid01.lab.local f_iis_kerb

# Set the SPN for the Short Name: 
setspn -S HTTP/vmhybrid01 f_iis_kerb

```
Get spn

```ps1
setspn -L f_iis_kerb
Registered ServicePrincipalNames for CN=IIS Kerberos Service,CN=Users,DC=lab,DC=local:
        HTTP/vmhybrid01.lab.local
        HTTP/vmhybrid01
```

Run as

![run_as](https://github.com/spawnmarvel/todo-and-current/blob/main/iis_kerberos_app/images/run_as.png)

Permissions Check

For the site to load, the service account f_iis_kerb needs permission to read this folder:
🔹 Right-click the kerbtest folder > Properties.
🔹 Go to the Security tab and click Edit.
🔹 Add f_iis_kerb and grant it Read & execute, List folder contents, and Read


![folder security](https://github.com/spawnmarvel/todo-and-current/blob/main/iis_kerberos_app/images/folder.png)

* dsa.exe

![f_iis_kerb](https://github.com/spawnmarvel/todo-and-current/blob/main/iis_kerberos_app/images/f_iis_kerb.png)


🟢 What is Correct

🔹 Encryption: AES 128 and AES 256 are both enabled. This is ideal for modern Kerberos security.

🔹 SPNs: You have registered HTTP/vmhybrid01 and HTTP/vmhybrid01.lab.local. This covers both the short name and the FQDN.

🔹 Delegation: You have "Constrained Delegation" enabled for the cifs service on vmhybrid01.lab.local. This is correct if your web app needs to access file shares on that server using the user's identity.

🔴 Critical Security Risk: Admin Membership

In the bottom right "Attribute Editor" snippet, I see:
memberOf: CN=Administrators,CN=Builtin,DC=lab,DC=local

You should remove this user from the Domain "Administrators" group. A service account running an IIS App Pool should never be a Domain Admin or a Builtin Administrator. 

It only needs "Log on as a batch job" rights on the local web server and "Read" permissions on your application folder. Keeping it as an admin creates a significant security vulnerability.

🟡 Configuration Note: Delegation Type

On the Delegation tab, you have selected "Use any authentication protocol" (Protocol Transition).

🔹 This is fine, but it is "less secure" than "Use Kerberos only."

🔹 Use "any authentication protocol" if users might connect via NTLM or other methods but you still need the app to "transition" them to Kerberos to talk to the backend cifs service.


[!IMPORTANT]
Ensure the user f_iis_kerb has "Trusted for delegation" enabled in AD if you plan to pass these credentials to a backend database or another service.

## 3. IIS Configuration
Follow these steps to configure the App Pool and the Site:

1. Create the Application Pool

* In IIS Manager, right-click Application Pools and select Add Application Pool.

* Name it KerbAppPool.

* Keep .NET CLR version at .NET CLR Version v4.0.30319 and Managed pipeline mode as Integrated.

* Click OK.


![apppool](https://github.com/spawnmarvel/todo-and-current/blob/main/iis_kerberos_app/images/apppool.png)

2. Set the Identity (The "Who")

* Select KerbAppPool in the list and click Advanced Settings in the right-hand "Actions" pane.

* Find Identity, click the ... button.

* Choose Custom account and click Set.

* Enter LAB\f_iis_kerb and the password.

* While still in Advanced Settings, find Load User Profile and set it to True.

![identity](https://github.com/spawnmarvel/todo-and-current/blob/main/iis_kerberos_app/images/identity.png)

3. Creating the Site and Assigning the App Pool

Open IIS Manager.

* Add the Site:

* Right-click Sites in the left-hand connections tree.

* Select Add Website...

* Fill in the Details:

* Site name: KerberosTest

* Application pool: Click Select... and choose the KerbAppPool you just created.

* Physical path: Browse to C:\inetpub\kerbtest.

* Binding: * Type: http

* IP address: All Unassigned

* Port: 80 (or another port if 80 is taken).

* Host name: Enter vmhybrid01.lab.local (this must match the SPN we saw in your screenshot).

Click OK.

![new site](https://github.com/spawnmarvel/todo-and-current/blob/main/iis_kerberos_app/images/new_site.png)

Sitea app

![site_app](https://github.com/spawnmarvel/todo-and-current/blob/main/iis_kerberos_app/images/site_app.png)


## 4. Enable Windows Authentication

1. Enable Windows Authentication

* In the left tree of IIS Manager, click on your new site, KerberosTest.

* In the center pane (Features View), double-click the Authentication icon.

* Disable "Anonymous Authentication" (this is vital, otherwise IIS won't ask for credentials).

* Enable "Windows Authentication".

2. Configure Providers (Negotiate)

The "Provider" tells IIS which security protocol to try first.

Select Windows Authentication so it is highlighted.

In the right-hand Actions pane (or by right-clicking), click Providers....

Ensure Negotiate is at the top of the list.

Ensure NTLM is second.

Click OK.

Note: "Negotiate" is the mechanism that allows Kerberos to happen.

![providers](https://github.com/spawnmarvel/todo-and-current/blob/main/iis_kerberos_app/images/providers.png)

3. Adjust Advanced Settings

* This part is often missed, but it is critical when using a custom service account like f_iis_kerb.

* While still in the Authentication screen, click Advanced Settings... in the right-hand pane.

* Uncheck "Enable Kernel-mode authentication".

Reason: Kernel mode tries to use the machine's local identity to decrypt tickets. 

We want to use the f_iis_kerb identity instead.


![kernel_off](https://github.com/spawnmarvel/todo-and-current/blob/main/iis_kerberos_app/images/kernel_off.png)

* Ensure Extended Protection is set to Off (to avoid 401 errors during initial testing).

* Click OK.

One final "hidden" setting

We need to tell IIS explicitly to use the App Pool's credentials to look up the Kerberos SPN.

Click on your site (KerberosTest) in the left panel.

In the center pane, double-click Configuration Editor.

At the top, change the Section dropdown to:
system.webServer/security/authentication/windowsAuthentication

Find the row for useAppPoolCredentials and change it from False to True.

Click Apply in the top-right corner.

![use app pool cred](https://github.com/spawnmarvel/todo-and-current/blob/main/iis_kerberos_app/images/true.png)


NTFS Verification

```ps1
# Check permissions for the folder
get-acl "C:\inetpub\kerbtest" | select-object -expandproperty access | where-object {$_.IdentityReference -like "*f_iis_kerb*"}
```

Result

```txt
FileSystemRights  : ReadAndExecute, Synchronize
AccessControlType : Allow
IdentityReference : LAB\f_iis_kerb
IsInherited       : False
InheritanceFlags  : ContainerInherit, ObjectInherit
PropagationFlags  : None
```

## Final "Ready to Test" Checklist

Before you open the browser, perform a quick reset to make sure all these IIS and NTFS changes are "live":

* Open an Administrative Command Prompt.

* Type iisreset and hit Enter.

How to test on localhost

* Navigate to http://vmhybrid01.lab.local:8080


![test localhost](https://github.com/spawnmarvel/todo-and-current/blob/main/iis_kerberos_app/images/test_localhost.png)

That is a perfect result! Seeing Negotiate while the App Pool Identity is LAB\f_iis_kerb confirms that your SPN, the useAppPoolCredentials setting, and the App Pool identity are all working in harmony.

---

How to Test On a different machine (a client joined to the same domain), open a browser.

* Navigate to http://vmhybrid01.lab.local:8080

* If a login box appears, enter your own domain credentials (not the service account).

* Once the page loads, look at Auth Type:

* Negotiate = Success (Kerberos is working).

* NTLM = Something is wrong (usually an SPN mismatch or Browser Intranet Zone issue).

![remote vm](https://github.com/spawnmarvel/todo-and-current/blob/main/iis_kerberos_app/images/remote_vm.png)