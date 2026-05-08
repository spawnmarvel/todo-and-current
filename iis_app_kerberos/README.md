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

## Step 4: Configure the IIS Application Pool

Now we tell IIS to "log in" as this domain account.

* Open IIS Manager.

* Go to Application Pools.

* Right-click your site's pool > Advanced Settings.

* Change Identity to Custom Account and enter lab\f_iis_kerb.

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
    <h3>Files in Share (\\vmhybrid01\DataShare):</h3>
    <ul>
        <% 
        try {
            string sharePath = @"\\vmhybrid01\DataShare";
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

## Step 6: Authentication Providers and Permissions

Finally, ensure IIS is set to use the correct "handshake" protocol.

* In IIS, click your Site > Authentication.

* Enable Windows Authentication.

* Right-click Windows Authentication > Providers.

* Ensure Negotiate is at the top.

* Share Permissions: Go to your C:\RemoteData folder. Ensure f_iis_kerb has Read access in both the Sharing and Security tabs.

## How to verify in your lab

On a client VM, open the site using the FQDN: [http://vmhybrid01.lab.local](http://vmhybrid01.lab.local).

* If you see the files: Success! Kerberos delegated your identity to the share.

* Run klist in PowerShell on the client: You should see a ticket for HTTP/vmhybrid01.


If you get an "Access Denied" for the files but the page loads, it usually means the Delegation step in AD wasn't applied or the SPN is missing.