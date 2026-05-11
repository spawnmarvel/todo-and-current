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
![f_iis_kerb](https://github.com/spawnmarvel/todo-and-current/blob/main/iis_kerberos_app/images/f_iis_kerb.png)

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


[!IMPORTANT]
Ensure the user f_iis_kerb has "Trusted for delegation" enabled in AD if you plan to pass these credentials to a backend database or another service.

## 3. IIS Configuration
Follow these steps to configure the App Pool and the Site:

Create and Configure the App Pool
🔹 Identity: Open IIS Manager > Application Pools. Select your pool > Advanced Settings. Change Identity to f_iis_kerb.
🔹 Load User Profile: Set Load User Profile to True.

Configure Authentication
🔹 Disable Anonymous: Go to your Site > Authentication. Disable Anonymous Authentication.
🔹 Enable Windows Auth: Enable Windows Authentication.
🔹 Providers: Right-click Windows Authentication > Providers. Ensure Negotiate is at the top, followed by NTLM.

Advanced Settings (Kernel Mode)
🔹 Right-click Windows Authentication > Advanced Settings.
🔹 Ensure Extended Protection is Off (for initial testing).
🔹 Enable Kernel-mode authentication should be checked, but if you are using a custom service account like f_iis_kerb, you may need to disable it or configure useAppPoolCredentials in the configuration editor

## 4. Setting useAppPoolCredentials
To ensure IIS uses the service account's SPN instead of the Computer Account's SPN:

* In IIS Manager, select the Site.

* Open Configuration Editor.

* Navigate to system.webServer/security/authentication/windowsAuthentication.

* Set useAppPoolCredentials to True.

* Click Apply.

## 5. Client-Side Browser Setup

For the browser to send Kerberos tickets:
🔹 Add the URL ([https://webserver.domain.com](https://webserver.domain.com)) to the Local Intranet zone in Internet Options.
🔹 Ensure "Enable Integrated Windows Authentication" is checked in the browser's advanced settings.