# IIS web app with a remote storage account with auth Negotiate and NTLM


Setting up Kerberos authentication for an IIS site that accesses a remote file share involves several moving parts, primarily dealing with Double-Hop authentication. Since you are using a local account for the ASP.NET authentication but want to use Negotiate/NTLM for the site, there are specific configuration steps to ensure the identity flows correctly.

## Phase 1: IIS and Site Configuration

First, ensure the Web Server (IIS) role is installed with Windows Authentication enabled.

1. Install Windows Authentication:

* Open Server Manager > Add Roles and Features.

* Navigate to Web Server (IIS) > Web Server > Security.

* Check Windows Authentication.

2. Configure Authentication Providers:

* Select your site in IIS Manager.

* Double-click Authentication.

* Enable Windows Authentication (Disable Anonymous).

* Right-click Windows Authentication > Providers.

* Ensure Negotiate is at the top, followed by NTLM.

### Set up the Virtual Directory:

* Right-click your site > Add Virtual Directory.

* Alias: Files

* Physical Path: \\RemoteServer\ShareName

* Click Connect As... and enter the credentials of the local account or a domain account that has permissions to the share.

## Phase 2: Solving the "Double-Hop" Issue

When a user connects to IIS via Kerberos (Negotiate) and IIS tries to access a remote share, the "Double-Hop" problem occurs: IIS cannot "pass" the user's credentials to the second server unless Kerberos Delegation is configured.

1. SPN (Service Principal Name) Registration

You must link the service to a specific account. If the App Pool is running as NetworkService, the SPN is linked to the Computer Account. If it's a domain user, link it to that user.

```ps1
# Example for a computer account
setspn -S HTTP/YourServerName YourServerName
setspn -S HTTP/YourServerName.domain.com YourServerName
```

2. Active Directory Delegation

* Open Active Directory Users and Computers.

* Find the Computer (or User) account running the IIS Application Pool.

* Go to the Delegation tab.

* Select "Trust this computer for delegation to any service (Kerberos only)" or use Constrained Delegation for better security to specifically allow cifs (File Shares) on the target server.

## Phase 3: PowerShell Script to List Files

This script (Version 1.0) is a basic ASP.NET (C#) or PowerShell-based logic to list files from the mapped path. Save this as default.aspx in your site root.

```ps1
# Version 1.0
# This script lists files from the designated file share path within the IIS environment.

$sharePath = "\\RemoteServer\ShareName"

try {
    Write-Host "Checking path: $sharePath" -ForegroundColor White
    $files = Get-ChildItem -Path $sharePath
    
    if ($files.Count -eq 0) {
        Write-Host "Found in these files : None" -ForegroundColor Red
    } else {
        foreach ($file in $files) {
            Write-Host "File: $($file.Name)" -ForegroundColor Green
        }
    }
}
catch {
    Write-Host "Error accessing file share: $($_.Exception.Message)" -ForegroundColor Red
}

```
Critical Considerations
* Provider Order: If Kerberos fails, IIS will fall back to NTLM. NTLM cannot perform delegation. If you see "Access Denied" on the file share but the website loads, you are likely falling back to NTLM.

* Kernel Mode Authentication: In IIS, under Windows Authentication > Advanced Settings, you may need to disable Kernel-mode authentication if you are using a custom domain account for the Application Pool to ensure SPNs are handled correctly.

* Local Account Limitation: Note that a Local Account on the IIS server cannot be "delegated" to a remote server. For true Kerberos flow to a remote share, the App Pool identity or the authenticated user should ideally be a Domain account.

