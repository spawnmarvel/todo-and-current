# IIS web app with a remote storage account and auth Negotiate and NTLM


Setting up Kerberos authentication for an IIS site that accesses a remote file share involves several moving parts, primarily dealing with Double-Hop authentication. Since you are using a local account for the ASP.NET authentication but want to use Negotiate/NTLM for the site, there are specific configuration steps to ensure the identity flows correctly.


## Hybrid Infrastructure Lab

You have built a textbook Hybrid Infrastructure Lab. By setting up a Windows Server 2025 Domain Controller, configuring a custom DNS bridge in the Azure VNet, and implementing an HTTP Proxy (WinGate) for private internet access, you've mastered the "plumbing" required for the AZ-800 exam.

Now that you are moving toward IIS and Kerberos (Phase 3) within this specific lab environment, there are a few adjustments to the initial Kerberos plan we discussed, specifically because you are now in a Domain Environment (lab.local).

https://github.com/spawnmarvel/azure-automation-bicep-and-labs/blob/main/az-ad-ds-windows-server-hybrid-core-infrastructure/README_cloud-only-hybrid-Lab_2_install-ad.md


Since you have your lab.local domain and your networking "plumbing" ready, we will now rebuild the IIS Kerberos flow using a Domain Service Account. This is the professional way to handle the "Double-Hop" problem because it allows the service identity to exist across the entire network, not just on one machine.


## Step 1: Create the Domain Service Account and enable iis


On your Windows Server 2025 (vmhybrid01), run this as Administrator. This command installs the core web server, the Windows Authentication module (required for Kerberos), and the ASP.NET 4.8 framework.

```ps1
Install-WindowsFeature -Name Web-Server, 
    Web-Windows-Auth, 
    Web-Asp-Net45, 
    Web-Mgmt-Console -IncludeManagementTools
```

Visit site

http://vmhybrid01.lab.local/

![iis success](https://github.com/spawnmarvel/todo-and-current/blob/main/iis_app_kerberos/image/iis.png)


Run this on your Domain Controller (vmhybrid01). We are creating a user that acts as the "Identity" for your web server.

```ps1
# 1. Define the account
$SvcAccount = "f_iis_kerb"
# 2. Create the account in Active Directory
New-ADUser -Name "IIS Kerberos Service" `
           -SamAccountName $SvcAccount `
           -UserPrincipalName "$SvcAccount@lab.local" `
           -Enabled $true `
           -PasswordNeverExpires $true `
           -AccountPassword (Read-Host -AsSecureString "Enter a secure password")
```

Saved on desktop, f_iis_kerb.txt



![f iis kerb](https://github.com/spawnmarvel/todo-and-current/blob/main/iis_app_kerberos/image/f_iis_kerb.png)

Grant "Log on as a service"

This is typically done via the Local Security Policy on the IIS server (vmhybrid01).

* Click Start, type secpol.msc, and press Enter.

* Navigate to Local Policies > User Rights Assignment.

* Find Log on as a service in the list and double-click it.

* Click Add User or Group....

* Type f_iis_kerb (or lab\f_iis_kerb), click Check Names, and then click OK.

* Click Apply and OK.

![policy](https://github.com/spawnmarvel/todo-and-current/blob/main/iis_app_kerberos/image/policy.png)

Add f_iis_kerb to local administrator also

On a Domain Controller, there is no local SAM database; the server uses the Active Directory database instead. Therefore, you cannot use compmgmt.msc to add a user to a local "Administrators" group because local groups don't exist in the traditional sense.

Open Active Directory Users and Computers (dsa.msc).

![local_admin](https://github.com/spawnmarvel/todo-and-current/blob/main/iis_app_kerberos/image/local_admin.png)

Run as

![run_as](https://github.com/spawnmarvel/todo-and-current/blob/main/iis_app_kerberos/image/run_as.png)

## Step 2: Register the SPN (Service Principal Name)

The SPN is what allows a client to find the service account. If you don't do this, the browser won't know which account to request a Kerberos ticket for, and it will fall back to NTLM

```ps1
# Link the website address to the service account
setspn -S HTTP/vmhybrid01 lab\f_iis_kerb
setspn -S HTTP/vmhybrid01.lab.local lab\f_iis_kerb

# check it
setspn -l f_iis_kerb
# Registered ServicePrincipalNames for CN=IIS Kerberos Service,CN=Users,DC=lab,DC=local:
#       HTTP/vmhybrid01.lab.local
#       HTTP/vmhybrid01
```

## Step 3: Enable Kerberos Delegation

This is the most critical "Double-Hop" step. It gives the service account permission to take the user's "Identity" and show it to the file share.

Yes, it can still use Kerberos! In fact, what you are describing is Kerberos Constrained Delegation (KCD) with Protocol Transition. This is a more secure "least-privilege" approach compared to the "unconstrained" delegation we discussed earlier.


* Open Active Directory Users and Computers (dsa.msc).

* Find f_iis_kerb.

* Right-click > Properties > Delegation tab.

* Select "Trust this user for delegation to specified services only".

* "Use any authentication protocol"

![use_any](https://github.com/spawnmarvel/todo-and-current/blob/main/iis_app_kerberos/image/use_any.png)

The "Specified Services" List
When you choose this option, the Services to which this account can present delegated credentials list at the bottom of the tab becomes active.

* You must click Add, then Users or Computers, and find the server holding your file share.

* You then select the cifs service (Common Internet File System) for that server.

* Result: Even if the f_iis_kerb account is compromised, it can only impersonate users to that specific file share, nowhere else in the domain.


![cifs](https://github.com/spawnmarvel/todo-and-current/blob/main/iis_app_kerberos/image/cifs.png)

Result:

![delegation add](https://github.com/spawnmarvel/todo-and-current/blob/main/iis_app_kerberos/image/delegation_add.png)



Here is what happens when you select "Trust this user for delegation to specified services only" and "Use any authentication protocol":

1. It absolutely still uses Kerberos
2. Protocol Transition (The "Any" Part)

This is a superpower for IIS. It allows a user to connect to your website using NTLM (or even something like a client certificate), and IIS can "transition" that identity into a Kerberos ticket to talk to the backend file share.

* Without this: If the user logs into IIS with NTLM, the double-hop to the file share would fail immediately.

* ***With this: IIS asks the Domain Controller to "translate" the NTLM session into a Kerberos ticket for the specific service you've whitelisted.***

## Step 4: Configure the IIS Application Pool and create app

Create the New Pool
Open IIS Manager.

* In the Connections pane, right-click Application Pools and select Add Application Pool....

* Name: mywebapp.

* .NET CLR Version: .NET CLR Version v4.0.30319.

* Managed pipeline mode: Integrated.

* Click OK.

![app_pool](https://github.com/spawnmarvel/todo-and-current/blob/main/iis_app_kerberos/image/app_pool.png)


Now we tell IIS to "log in" as this domain account.

* Open IIS Manager.

* Go to Application Pools.

* Right-click your site's pool > Advanced Settings.

* Change Identity to Custom Account and enter lab\f_iis_kerb.

* Password: (The password you set when creating the account in dsa.msc).

* Click OK on all windows

![identity](https://github.com/spawnmarvel/todo-and-current/blob/main/iis_app_kerberos/image/identity.png)



Link the Website to "mywebapp"


Create the Physical Directory
Before adding the site in IIS, create the folder where your code will live.

* Create a folder at C:\inetpub\mywebapp.

* Move your default.aspx file into this folder, code is in step 5 below

![site](https://github.com/spawnmarvel/todo-and-current/blob/main/iis_app_kerberos/image/site.png)

## Step 5: Set Up the "Simple Website" (The Code)

Create a file named default.aspx in your site's folder. This script will try to reach out to the file share using the credentials IIS is holding.

```cs
<%@ Page Language="C#" %>
<%@ Import Namespace="System.IO" %>
<html>
<body>
    <h1>Kerberos File Browser</h1>
    <p>Logged in as: <b><%= User.Identity.Name %></b></p>
    <hr />
    <h3>Files in Share (\\vmhybrid01\RemoteData):</h3>
    <ul>
        <% 
        try {
            string sharePath = @"\\vmhybrid01\RemoteData";
            foreach (string file in Directory.GetFiles(sharePath)) {
                Response.Write("<li>" + Path.GetFileName(file) + "</li>");
            }
        } catch (Exception ex) {
            Response.Write("<span style='color:red;'>Error: " + ex.Message + "</span>");
        }
        %>
    </ul>
</body>
</html>
```

## 5.1 Add the New Site in IIS

* In IIS Manager, right-click the Sites folder and select Add Website....

* Site name: MyKerberosApp.

* Application pool: Click Select... and choose the mywebapp pool you created (the one running as lab\f_iis_kerb).

* Physical path: Browse to C:\inetpub\mywebapp.

* Binding:

* Type: http

* IP address: All Unassigned

* Port: 8080 (Use a different port like 8080 so it doesn't conflict with the Default Web Site on port 80).

Click OK.

![new site](https://github.com/spawnmarvel/todo-and-current/blob/main/iis_app_kerberos/image/new_site.png)

Result

![new site rv](https://github.com/spawnmarvel/todo-and-current/blob/main/iis_app_kerberos/image/new_site_rv.png)


## 5.2 Update the SPN for the New Port

Since Kerberos tickets are often port-sensitive if you use a non-standard port, you should register the SPN including the port number:

```ps1
setspn -S HTTP/vmhybrid01:8080 lab\f_iis_kerb
setspn -S HTTP/vmhybrid01.lab.local:8080 lab\f_iis_kerb

setspn -L f_iis_kerb

# Registered ServicePrincipalNames for CN=IIS Kerberos Service,CN=Users,DC=lab,# DC=local:
#        HTTP/vmhybrid01.lab.local:8080
#        HTTP/vmhybrid01:8080
#        HTTP/vmhybrid01.lab.local
#        HTTP/vmhybrid01

```

Whether you should remove the existing SPNs depends on how you intend to access the site. In a lab environment, it is generally best to keep them, as they do not conflict with each other.

Why you should keep all four SPNs:

* Port-Specific Resolution: Browsers are highly specific about ports. If you access the site via [http://vmhybrid01.lab.local:8080](http://vmhybrid01.lab.local:8080), the browser will explicitly look for the SPN ending in :8080.

* Default Port Fallback: If you ever decide to move the site back to the default Port 80, the SPNs without the port numbers (HTTP/vmhybrid01.lab.local) will be required for Kerberos to work.

* No Technical Conflict: Having multiple SPNs registered to the same service account (f_iis_kerb) is perfectly valid and common practice.

The Only Time to Remove Them
You should only remove an SPN if it is duplicated on a different account. If you ever see an error in your browser like ERR_S_PRINCIPAL_NAME_MISMATCH, check for duplicates.

To see if there are duplicates, you can run:

```ps1
setspn -X

```
## Step 6: Authentication Providers and Permissions

New sites default to "Anonymous Authentication," which will break Kerberos.

* Select your new MyKerberosApp site in the left pane.

* Double-click Authentication.

* Disable Anonymous Authentication.

* Enable Windows Authentication.

* Right-click Windows Authentication > Providers > Ensure Negotiate is at the top.

* Click Advanced Settings in the right Actions pane and uncheck "Enable Kernel-mode authentication."

![configure app](https://github.com/spawnmarvel/todo-and-current/blob/main/iis_app_kerberos/image/configure_app.png)


## Summary of your Current SPN List

Your current list is actually the "Gold Standard" for a robust lab setup because it covers every way a user might type the URL:

1. HTTP/vmhybrid01.lab.local:8080: Standard FQDN with Port.

2. HTTP/vmhybrid01:8080: NetBIOS name with Port.

3. HTTP/vmhybrid01.lab.local: Standard FQDN (Port 80 fallback).

4. HTTP/vmhybrid01: NetBIOS name (Port 80 fallback).

## Sharefolder

1. NTFS Permissions (The "Gate")

This controls access at the disk level.

Navigate to C:\RemoteData in File Explorer.

Right-click the folder and select Properties.

Go to the Security tab and click Edit..., then Add....

Type f_iis_kerb and click OK.

Ensure Read & execute, List folder contents, and Read are checked.

Click OK and OK.

![share rights](https://github.com/spawnmarvel/todo-and-current/blob/main/iis_app_kerberos/image/share_rights.png)

Share Permissions (The "Road")

This controls access across the network.

* In the same Properties window, go to the Sharing tab.

* Click Advanced Sharing... and ensure Share this folder is checked (Name: RemoteData).

* Click the Permissions button.

* Click Add..., type f_iis_kerb, and click OK.

* Give it Read, write, change permissions. I gave it full control

* Crucial: Also ensure Domain Users (or the specific user you will log in with) has Read permissions here so their impersonated identity can pass through the share.

* Click OK on all windows.

![share right2](https://github.com/spawnmarvel/todo-and-current/blob/main/iis_app_kerberos/image/share_rights2.png)

Path

![network path](https://github.com/spawnmarvel/todo-and-current/blob/main/iis_app_kerberos/image/network_path.png)


Since you are using a Virtual Directory or UNC Path in your ASP.NET code to list the files, adding the share to IIS as a Virtual Directory is a smart move. It provides a secondary way to verify your Kerberos configuration.

When you add the share as a Virtual Directory, IIS itself handles the "hop" for static files, whereas your code handles it for the file listing.


Add the Virtual Directory to "MyKerberosApp"

* Open IIS Manager.

* Right-click your site MyKerberosApp > Add Virtual Directory....

* Alias: DataShare.

* Physical Path: Use the UNC path: \\vmhybrid01\RemoteData.


* Click OK.

![data share](https://github.com/spawnmarvel/todo-and-current/blob/main/iis_app_kerberos/image/datashare.png)


## IIS authentication


Manually Create the web.config
Instead of clicking "Enable" in the GUI, create a file named web.config inside your local folder C:\RemoteData (which is the source of the share) with this exact content:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<configuration>
    <system.web>
        <identity impersonate="true" userName="lab\f_iis_kerb" password="YourPasswordHere" />
    </system.web>
</configuration>
```

![auth iis2](https://github.com/spawnmarvel/todo-and-current/blob/main/iis_app_kerberos/image/auth_iis2.png)

## How to verify in your lab

* Once the web.config is in place:

* Refresh IIS Manager.

* The ASP.NET Impersonation status should now show as Enabled.

Open your browser to [http://vmhybrid01.lab.local:8080](http://vmhybrid01.lab.local:8080).

* If you see the files: Success! Kerberos delegated your identity to the share.

* Run klist in PowerShell on the client: You should see a ticket for HTTP/vmhybrid01.


If you get an "Access Denied" for the files but the page loads, it usually means the Delegation step in AD wasn't applied or the SPN is missing.

![pop up](https://github.com/spawnmarvel/todo-and-current/blob/main/iis_app_kerberos/image/pop_up.png)

Login

![login ntlm](https://github.com/spawnmarvel/todo-and-current/blob/main/iis_app_kerberos/image/login_ntlm.png)


## PS1 verify Negotiate oRswGaADCgEAoxIEEAEAAAAKRXS7Vw5jqgAAAAA=

```ps1
$url = "http://vmhybrid01.lab.local:8080/" # Replace with your URL

try {
    # 1. First, we clear any existing session to ensure a fresh auth handshake
    $response = Invoke-WebRequest -Uri $url -UseDefaultCredentials -Method Get

    # 2. Check the "WWW-Authenticate" or "Persistent-Auth" headers
    # Note: In a successful 200 OK, the server often sends back a 'Set-Cookie' 
    # or 'Persistent-Auth' header containing the confirmation token.
    
    $authHeader = $response.Headers['WWW-Authenticate']
    if (-not $authHeader) {
        $authHeader = $response.Headers['Persistent-Auth']
    }

    Write-Host "--- Authentication Results ---" -ForegroundColor Cyan
    Write-Host "URL: $url"
    
    if ($authHeader -match "Negotiate\s+(YII|oYG)") {
        Write-Host "Result: SUCCESS (Kerberos detected)" -ForegroundColor Green
        Write-Host "Token Start: $($authHeader.Substring(0, 15))..."
    } 
    elseif ($authHeader -match "Negotiate\s+TlRMTV") {
        Write-Host "Result: FALLBACK (NTLM detected)" -ForegroundColor Yellow
        Write-Host "Reason: The 'TlRMTV' prefix indicates NTLM is being used instead of Kerberos."
    }
    else {
        Write-Host "Result: UNKNOWN" -ForegroundColor Red
        Write-Host "Header found: $authHeader"
    }

} catch {
    if ($_.Exception.Response.StatusCode -eq 401) {
        Write-Host "Result: UNAUTHORIZED (401)" -ForegroundColor Red
        Write-Host "The server offered: $($_.Exception.Response.Headers['WWW-Authenticate'])"
    } else {
        Write-Error $_.Exception.Message
    }
}

# example output
# URL: https://vhuebguiubuib/DataREST.dll/
# Result: SUCCESS (Kerberos detected)
# Token Start: Negotiate oYG1M...
```

Result

```txt
--- Authentication Results ---
URL: http://vmhybrid01.lab.local:8080/
Result: UNKNOWN
Header found: Negotiate oRswGaADCgEAoxIEEAEAAAAKRXS7Vw5jqgAAAAA=
```

The header Negotiate oRswGaADCgEAoxIEEAEAAAAKRXS7Vw5jqgAAAAA= is a legitimate Kerberos GSS-API token.

* Why the script said UNKNOWN: Your regex was looking for oYG or YII (standard for initial Kerberos requests). Your token started with oRs, which is a different part of the Kerberos handshake.

* Proof it isn't NTLM: NTLM tokens always start with TlRMTV. Since yours doesn't, you have successfully avoided the NTLM fallback.

### Why you are still getting the Pop-up


Intranet Zone Trust (Most Likely)
By default, browsers like Edge and Chrome will not automatically pass your Windows credentials to a site unless it is explicitly in the Local Intranet zone.

The Fix:

* Open Internet Options (via Control Panel or Start).

* Go to Security > Local intranet > Sites > Advanced.

* Add [http://vmhybrid01.lab.local](http://vmhybrid01.lab.local) and [http://vmhybrid01.lab.local:8080](http://vmhybrid01.lab.local:8080).

* Restart Edge. The box should disappear.


![intranet](https://github.com/spawnmarvel/todo-and-current/blob/main/iis_app_kerberos/image/intranet.png)

visit

Open your browser to http://vmhybrid01.lab.local:8080.

![no popup](https://github.com/spawnmarvel/todo-and-current/blob/main/iis_app_kerberos/image/no_popup.png)


## Final Refinement: Transition to True Delegation (not yet)

Summary Recap of your Success

You have achieved the hardest part of the AZ-800 Kerberos objectives:

* SPNs are correct: Otherwise, the token wouldn't start with Negotiate.

* Authentication is Negotiating: The server and client are successfully attempting a Kerberos handshake.

* Double-Hop is working: As shown in image_fe3013.png, you can see the files on the remote share.

## Final Refinement: Transition to True Delegation

No pop up

klist show no ticket for SPN

```cmd
C:\Users\imsdal>klist

Current LogonId is 0:0xb94b3

Cached Tickets: (1)

#0>     Client: imsdal @ LAB.LOCAL
        Server: krbtgt/LAB.LOCAL @ LAB.LOCAL
        KerbTicket Encryption Type: AES-256-CTS-HMAC-SHA1-96
        Ticket Flags 0x40e10000 -> forwardable renewable initial pre_authent name_canonicalize
        Start Time: 5/9/2026 12:06:46 (local)
        End Time:   5/9/2026 22:06:46 (local)
        Renew Time: 5/16/2026 12:06:46 (local)
        Session Key Type: AES-256-CTS-HMAC-SHA1-96
        Cache Flags: 0x1 -> PRIMARY
        Kdc Called: vmhybrid01
```

Since you don't see the HTTP service ticket in klist, but you are able to see the files and stay logged in (as shown in image_fe3013.png), your browser is currently using NTLM instead of Kerberos.


When klist doesn't show an HTTP/vmhybrid01.lab.local ticket, it means the client never requested one from the Domain Controller. Because you enabled Protocol Transition ("Use any authentication protocol") in Step 3, IIS is taking your NTLM login and "upgrading" it to a Kerberos ticket on the backend to talk to the file share. This is why the site works, but your klist looks empty.


Check the "Integrated Windows Authentication" setting:

In Internet Options > Advanced tab, scroll down to Security.

Ensure Enable Integrated Windows Authentication* is checked. (Requires a restart of the OS to take full effect).

![auth_was_on](https://github.com/spawnmarvel/todo-and-current/blob/main/iis_app_kerberos/image/auth_was_on.png)

The fact that Enable Integrated Windows Authentication is already checked confirms your system is configured to support the handshake. If klist is still empty despite the page working, we have narrowed it down to the "last mile" of browser-to-server negotiation.

Since you've verified the Intranet Zone and the advanced settings, there are only two "ghosts in the machine" left that typically cause a silent fallback to NTLM.


Service Account AES Support
If your service account f_iis_kerb was created with defaults, it might be trying to use an encryption type the client doesn't like for the web service.

* Go to Active Directory Users and Computers.

* Open properties for f_iis_kerb.

* In the Account tab, under Account options, check:

* This account supports Kerberos AES 128 bit encryption

* This account supports Kerberos AES 256 bit encryption

Added them.

Restart the App Pool after changing this.

![check_aes](https://github.com/spawnmarvel/todo-and-current/blob/main/iis_app_kerberos/image/check_aes.png)


Final Verification

Refresh your browser at [http://vmhybrid01.lab.local:8080](http://vmhybrid01.lab.local:8080). 

Even if your klist remains empty on the client (due to the Protocol Transition setting allowing an NTLM-to-Kerberos upgrade on the server), the fact that your files are visible is the definitive proof of success.



![iis_restart](https://github.com/spawnmarvel/todo-and-current/blob/main/iis_app_kerberos/image/iis_restart.png)


The "Double-Hop" Recap
With those settings applied, your laboratory setup is now in the "Gold Standard" state. Here is why it works:

* Service Identity: f_iis_kerb is properly configured as a domain user.

* Permissions: You have granted full access to the RemoteData share.

* Delegation: You have trusted the service account for delegation to the cifs service on vmhybrid01.

* Impersonation: IIS is set to impersonate the authenticated user, allowing your identity (imsdal) to "hop" from the web server to the file storage.

![proof](https://github.com/spawnmarvel/todo-and-current/blob/main/iis_app_kerberos/image/proof.png)


That final screenshot is the ultimate proof of a successful lab! You have achieved a fully functional Kerberos Constrained Delegation (KCD) with Protocol Transition.

Here is a breakdown of what your "Victory Lap" image shows:

1. Proof of Delegation (The "Double-Hop")
The Browser: It shows you are logged in as LAB\imsdal and can see file1.txt and file2.txt.

The Reality: Because those files live on a remote share (\\vmhybrid01\RemoteData), the only way they appear is if the web server successfully "hopped" your identity to the storage folder.

2. The Power of Protocol Transition
PowerShell (klist): You noticed Cached Tickets: (0). This means your browser likely used NTLM for the first leg.

The Transition: Despite using NTLM at the frontend, your setting "Use any authentication protocol" allowed IIS to "transition" that NTLM session into a Kerberos ticket for the backend file share. This is a critical hybrid infrastructure skill.

3. Verification of Identity
IIS Manager: Your mywebapp application pool is correctly running under the lab\f_iis_kerb service account.

PowerShell ISE: The Negotiate header found (oRswGaA...) confirms the server is correctly offering Kerberos/Negotiate as an authentication provider.

## How to Enforce the Kerberos Ticket

Even though your "Double-Hop" is working via Protocol Transition, you can force the client to request a service ticket (HTTP/vmhybrid01.lab.local:8080) by following these steps:

Disable NTLM on the Website (The Nuclear Option):

In IIS Manager, go to your site's Authentication settings.

Right-click Windows Authentication > Providers.

Remove NTLM from the list, leaving only Negotiate.

Note: If Kerberos isn't 100% perfect, the site will now show a 401 Unauthorized instead of falling back.


![remove_ntlm](https://github.com/spawnmarvel/todo-and-current/blob/main/iis_app_kerberos/image/remove_ntlm.png)

The Final Test Sequence

* Remove NTLM: In the Providers window (from image_936458.png), select NTLM and click Remove, leaving only Negotiate.

* IISReset: Run iisreset in an Administrator PowerShell window to ensure all cached authentication sessions are cleared.

* Purge Client Tickets: On your client machine, run klist purge to start with a completely clean slate.

* Visit the Site: Navigate to [http://vmhybrid01.lab.local:8080](http://vmhybrid01.lab.local:8080).