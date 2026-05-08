# IIS web app with a remote storage account with auth Negotiate and NTLM


Setting up Kerberos authentication for an IIS site that accesses a remote file share involves several moving parts, primarily dealing with Double-Hop authentication. Since you are using a local account for the ASP.NET authentication but want to use Negotiate/NTLM for the site, there are specific configuration steps to ensure the identity flows correctly.


## Hybrid Infrastructure Lab

You have built a textbook Hybrid Infrastructure Lab. By setting up a Windows Server 2025 Domain Controller, configuring a custom DNS bridge in the Azure VNet, and implementing an HTTP Proxy (WinGate) for private internet access, you've mastered the "plumbing" required for the AZ-800 exam.

Now that you are moving toward IIS and Kerberos (Phase 3) within this specific lab environment, there are a few adjustments to the initial Kerberos plan we discussed, specifically because you are now in a Domain Environment (lab.local).

https://github.com/spawnmarvel/azure-automation-bicep-and-labs/blob/main/az-ad-ds-windows-server-hybrid-core-infrastructure/README_cloud-only-hybrid-Lab_2_install-ad.md


Since you have your lab.local domain and your networking "plumbing" ready, we will now rebuild the IIS Kerberos flow using a Domain Service Account. This is the professional way to handle the "Double-Hop" problem because it allows the service identity to exist across the entire network, not just on one machine.


## Step 1: Create the Domain Service Account

Run this on your Domain Controller (vmhybrid01). We are creating a user that acts as the "Identity" for your web server.

```ps1
# 1. Define the account
$SvcAccount = "svc_iis_kerb"

# 2. Create the account in Active Directory
New-ADUser -Name "IIS Kerberos Service" `
           -SamAccountName $SvcAccount `
           -UserPrincipalName "$SvcAccount@lab.local" `
           -Enabled $true `
           -PasswordNeverExpires $true `
           -AccountPassword (Read-Host -AsSecureString "Enter a secure password")
```

## Step 2: Register the SPN (Service Principal Name)

The SPN is what allows a client to find the service account. If you don't do this, the browser won't know which account to request a Kerberos ticket for, and it will fall back to NTLM

```ps1
# Link the website address to the service account
setspn -S HTTP/vmhybrid01 lab\svc_iis_kerb
setspn -S HTTP/vmhybrid01.lab.local lab\svc_iis_kerb
```

## Step 3: Enable Kerberos Delegation

This is the most critical "Double-Hop" step. It gives the service account permission to take the user's "Identity" and show it to the file share.

* Open Active Directory Users and Computers (dsa.msc).

* Find svc_iis_kerb.

* Right-click > Properties > Delegation tab.

* Select "Trust this user for delegation to any service (Kerberos only)".

## Step 4: Configure the IIS Application Pool

Now we tell IIS to "log in" as this domain account.

* Open IIS Manager.

* Go to Application Pools.

* Right-click your site's pool > Advanced Settings.

* Change Identity to Custom Account and enter lab\svc_iis_kerb.

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

* Share Permissions: Go to your C:\RemoteData folder. Ensure svc_iis_kerb has Read access in both the Sharing and Security tabs.

## How to verify in your lab

On a client VM, open the site using the FQDN: [http://vmhybrid01.lab.local](http://vmhybrid01.lab.local).

* If you see the files: Success! Kerberos delegated your identity to the share.

* Run klist in PowerShell on the client: You should see a ticket for HTTP/vmhybrid01.


If you get an "Access Denied" for the files but the page loads, it usually means the Delegation step in AD wasn't applied or the SPN is missing.