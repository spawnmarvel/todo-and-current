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


![test localhost2](https://github.com/spawnmarvel/todo-and-current/blob/main/iis_kerberos_app/images/test_localhost2.png)

That is a perfect result! Seeing Negotiate while the App Pool Identity is LAB\f_iis_kerb confirms that your SPN, the useAppPoolCredentials setting, and the App Pool identity are all working in harmony.

---

How to Test On a different machine (a client joined to the same domain), open a browser.

* Navigate to http://vmhybrid01.lab.local:8080

* If a login box appears, enter your own domain credentials (not the service account).

* Once the page loads, look at Auth Type:

* Negotiate = Success (Kerberos is working).

* NTLM = Something is wrong (usually an SPN mismatch or Browser Intranet Zone issue).

![remote vm2](https://github.com/spawnmarvel/todo-and-current/blob/main/iis_kerberos_app/images/remote_vm2.png)

klist 

```cmd
C:\Users\imsdal.LAB>hostname
vmap2203

C:\Users\imsdal.LAB>klist

Current LogonId is 0:0xb280d

Cached Tickets: (2)

#0>     Client: imsdal @ LAB.LOCAL
        Server: krbtgt/LAB.LOCAL @ LAB.LOCAL
        KerbTicket Encryption Type: AES-256-CTS-HMAC-SHA1-96
        Ticket Flags 0x40e10000 -> forwardable renewable initial pre_authent name_canonicalize
        Start Time: 5/11/2026 18:48:46 (local)
        End Time:   5/12/2026 4:48:46 (local)
        Renew Time: 5/18/2026 18:48:46 (local)
        Session Key Type: AES-256-CTS-HMAC-SHA1-96
        Cache Flags: 0x1 -> PRIMARY
        Kdc Called: vmhybrid01.lab.local

#1>     Client: imsdal @ LAB.LOCAL
        Server: LDAP/vmhybrid01.lab.local/lab.local @ LAB.LOCAL
        KerbTicket Encryption Type: AES-256-CTS-HMAC-SHA1-96
        Ticket Flags 0x40a50000 -> forwardable renewable pre_authent ok_as_delegate name_canonicalize
        Start Time: 5/11/2026 18:48:46 (local)
        End Time:   5/12/2026 4:48:46 (local)
        Renew Time: 5/18/2026 18:48:46 (local)
        Session Key Type: AES-256-CTS-HMAC-SHA1-96
        Cache Flags: 0
        Kdc Called: vmhybrid01.lab.local
```

This is a major success! The page displaying Negotiate on the remote host vmap2203 means the Kerberos handshake was successful.

However, looking at your klist output, we can see exactly how the "Double Hop" and delegation logic is playing out.

Analyzing your klist results

🔹 Ticket #0 (krbtgt): This is your TGT (Ticket Granting Ticket). It's your "passport" that proves who you are to the Domain Controller so you can ask for other service tickets.

🔹 Ticket #1 (LDAP): This is a service ticket for LDAP. Notice the flag ok_as_delegate. This is appearing because you configured Constrained Delegation on the f_iis_kerb account earlier.


### Why don't you see an HTTP/vmhybrid01 ticket yet?

If the browser is showing Negotiate, a ticket was definitely used. Sometimes klist doesn't show it immediately if the session is cached or if the browser is using a different logon session.

The reason you are seeing a login pop-up and no HTTP ticket in klist—even though the page says "Negotiate"—is because the browser has actually fallen back to NTLM.

When the browser provides the "Negotiate" mechanism, it first tries to find a Kerberos ticket. If it fails, it uses NTLM. NTLM is technically a "Negotiate" sub-protocol, which is why your ASPX page still reports "Negotiate" as the auth type, but your identity is actually being verified via NTLM (which doesn't create a ticket in klist).

![popup](https://github.com/spawnmarvel/todo-and-current/blob/main/iis_kerberos_app/images/pop_up.png)


## Why Kerberos is failing on Port 8080

There are two specific reasons why this is happening:

1. The Port in the SPN
By default, browsers ignore the port number when generating an SPN request. When you visit http://vmhybrid01.lab.local:8080, the browser looks for HTTP/vmhybrid01.lab.local.

The Problem: If your browser is configured to be "strict" (common in modern Edge/Chrome), it might be looking for an SPN that includes the port: HTTP/vmhybrid01.lab.local:8080.

The Fix: You should add a second set of SPNs that explicitly include the port:

```cmd
setspn -S HTTP/vmhybrid01.lab.local:8080 f_iis_kerb
setspn -S HTTP/vmhybrid01:8080 f_iis_kerb

setspn -L f_iis_kerb

Registered ServicePrincipalNames for CN=IIS Kerberos Service,CN=Users,DC=lab,DC=local:
        HTTP/vmhybrid01:8080
        HTTP/vmhybrid01.lab.local:8080
        HTTP/vmhybrid01.lab.local
        HTTP/vmhybrid01

```

The login popup and the empty klist (0 cached tickets) mean the browser is still refusing to use Kerberos, even though the SPNs are now perfect. Since the SPNs are registered to a user account (f_iis_kerb), any "Security" mismatch will cause the browser to stop and ask for credentials manually.

Here is how to clear the "Pop-up" hurdle:

1. The "Intranet Zone" Rule
Even with the correct SPNs, browsers like Edge and Chrome will not send a Kerberos ticket to a site unless they are 100% sure it is a "Local Intranet" site. If it thinks it's an "Internet" site, it will prompt for a login as a security precaution.

On vmap2203, do this:

🔹 Open Internet Options (inetcpl.cpl).

🔹 Go to Security > Local Intranet > Sites > Advanced.

🔹 Add http://vmhybrid01.lab.local (and http://vmhybrid01 if you use the short name).

🔹 Crucial: Ensure "Require server verification (https:)" is unchecked since you are using port 80/8080.

![intranet](https://github.com/spawnmarvel/todo-and-current/blob/main/iis_kerberos_app/images/intranet.png)

## Browser "Strict" SPN Lookups

Some modern browsers are very picky about ports. Now that you added the port-specific SPNs, you should close all browser windows on vmap2203. Kerberos tickets are often requested only at the start of a session.

* Close Edge/Chrome.

* Open CMD and run klist purge.

* Re-open the browser and go to http://vmhybrid01.lab.local:8080

![remote vm nopop](https://github.com/spawnmarvel/todo-and-current/blob/main/iis_kerberos_app/images/remote_vm_no_pop.png)

```cmd

Cached Tickets: (2)

#0>     Client: imsdal @ LAB.LOCAL
        Server: krbtgt/LAB.LOCAL @ LAB.LOCAL
        KerbTicket Encryption Type: AES-256-CTS-HMAC-SHA1-96
        Ticket Flags 0x40e10000 -> forwardable renewable initial pre_authent name_canonicalize
        Start Time: 5/11/2026 19:22:39 (local)
        End Time:   5/12/2026 5:22:39 (local)
        Renew Time: 5/18/2026 19:22:39 (local)
        Session Key Type: AES-256-CTS-HMAC-SHA1-96
        Cache Flags: 0x1 -> PRIMARY
        Kdc Called: vmhybrid01.lab.local

#1>     Client: imsdal @ LAB.LOCAL
        Server: HTTP/vmhybrid01.lab.local @ LAB.LOCAL
        KerbTicket Encryption Type: AES-256-CTS-HMAC-SHA1-96
        Ticket Flags 0x40a10000 -> forwardable renewable pre_authent name_canonicalize
        Start Time: 5/11/2026 19:22:39 (local)
        End Time:   5/12/2026 5:22:39 (local)
        Renew Time: 5/18/2026 19:22:39 (local)
        Session Key Type: AES-256-CTS-HMAC-SHA1-96
        Cache Flags: 0
        Kdc Called: vmhybrid01.lab.local

C:\Windows\System32>hostname
vmap2203
```


## Perfect! That klist output is the "Gold Standard" proof.

Ticket #1 specifically shows Server: HTTP/vmhybrid01.lab.local @ LAB.LOCAL. This confirms that:

* The client (vmap2203) successfully requested a service ticket from the Domain Controller.

* The Domain Controller found the SPN you registered on the f_iis_kerb account.

* The browser successfully used that ticket to authenticate to IIS.

## Why you might still see a login prompt

* Since the Kerberos ticket is now officially in your cache, if you are still getting a login popup, it is usually down to one of two things:

* Credential Persistence: If you manually typed credentials into that popup earlier, the browser might be "remembering" those and using NTLM anyway.

* Fix: Close the browser, run klist purge, and open it again.

![remote vm nopop2](https://github.com/spawnmarvel/todo-and-current/blob/main/iis_kerberos_app/images/remote_vm_no_pop2.png)

ps1 script

```ps1
--- Authentication Results ---
URL: http://vmhybrid01.lab.local:8080
Result: SUCCESS (Kerberos detected)
Token Start: Negotiate oYG1M...

--- Authentication Results ---
URL: http://vmhybrid01.lab.local
Result: UNKNOWN
Header found: 


--- Authentication Results ---
URL: http://vmhybrid01
Result: UNKNOWN
Header found: 

--- Script fails---

http://vmhybrid01:8080

```

![ps1](https://github.com/spawnmarvel/todo-and-current/blob/main/iis_kerberos_app/images/ps1.png)


PowerShell Result: Your script shows the Token start with oYG.... In the world of Kerberos, seeing a GSSAPI header starting with oY is the cryptographic "handshake" that confirms it's a Kerberos blob, not an NTLM one (which starts with TlR).

The reason the script is returning UNKNOWN for the other URLs is likely because the authentication handshake was already completed in the underlying session or the headers didn't match the specific regex pattern on the final 200 OK response.

## Why the other URLs showed "UNKNOWN"

🔹 Session Persistence: Once you authenticate to vmhybrid01.lab.local on port 8080, the underlying .NET connection pool often keeps that authenticated socket open. When you then hit port 80 or the short name, the server may not send the Persistent-Auth header again because it already knows who you are.
🔹 SPN Mismatch: If http://vmhybrid01 (short name) doesn't have the site added to the Local Intranet Zone, the browser/PowerShell might not attempt the Negotiate handshake at all, leading to an empty header.

Troubleshooting the "Script Fails" for http://vmhybrid01:8080
If the script fails entirely on the short name:

Check DNS: Ensure ping vmhybrid01 actually resolves to the IP.

Check SPN: Run setspn -L f_iis_kerb to ensure HTTP/vmhybrid01:8080 is listed exactly like that.

Check Intranet Zone: Ensure the short name http://vmhybrid01 is also in your Local Intranet sites list in Internet Options.

The "Double-Hop" Requirement: 

If the ASPX page itself is trying to reach out to another service (like the cifs delegation we saw in your screenshot) and failing, IIS might throw a 401 challenge that looks like a login prompt.

## Final "Maintenance" Tips

Now that it’s working, here are three things to keep in mind so it doesn't break later:

SPN Management: 

* If you ever add a load balancer or a DNS alias (like https://myapp.lab.local), you must add that new name as an SPN to the f_iis_kerb account, or it will immediately revert to NTLM for that URL.

Password Rotation: 

* If you change the password for f_iis_kerb, you don't need to redo the SPNs, but you must update the password in the IIS Application Pool identity and run an iisreset.

Delegation (The "Double Hop"): 

* Your first screenshot showed constrained delegation for cifs. If your ASPX app ever needs to read a file from a remote share, you can now use WindowsIdentity.RunImpersonated in your C# code to "act as" the user imsdal on that remote share.

You've built a rock-solid, production-grade authentication flow. Are there any other backend services you're planning to connect to this app, or is this lab complete?