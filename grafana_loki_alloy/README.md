# Grafana, Loki and Allow

## Filebeat, Elastic Search and Kibana

We tested that, it is ok, but Kibana has some extra clutter and very big gui.

https://github.com/spawnmarvel/linux-and-azure/tree/main/azure-extra-linux-vm/kibana-elasticsearch-file-beat


Lets test a simpler stack

## Test it in Windows

## 1. Grafana on Windows
Grafana provides a standard Windows installer (.msi) or a standalone .zip file.

🔷 Installation: Download the installer from the official Grafana download page.

Grafana OSS

* https://grafana.com/grafana/download/12.4.0?edition=oss&platform=windows
* grafana_12.4.0_22325204712_windows_amd64.msi and run it.


🔷 Service: It installs as a Windows Service automatically, meaning it will start whenever the server reboots.

![install grafana](https://github.com/spawnmarvel/todo-and-current/blob/main/grafana_loki_alloy/images/install_grafana.png)

It builds a services using NSSM

![grafana servic](https://github.com/spawnmarvel/todo-and-current/blob/main/grafana_loki_alloy/images/grafana_service.png)

Files

* C:\Program Files\GrafanaLabs
* C:\Program Files\GrafanaLabs\grafana\conf\default.ini
* C:\Program Files\GrafanaLabs\grafana\data
* C:\Program Files\GrafanaLabs\grafana\data\log
* C:/Program Files/GrafanaLabs/grafana/data/plugins

🔷 Access: By default, it runs on http://localhost:3000.

🔷 Set up ssl

```ps1
# 1. Create the certificate in the Windows Store
$cert = New-SelfSignedCertificate -DnsName "vmhybrid.lab.local" -CertStoreLocation "Cert:\LocalMachine\My" -NotAfter (Get-Date).AddYears(3)

# 2. Set a temporary password for the export process
$pwd = ConvertTo-SecureString -String "A-PASSWORD" -Force -AsPlainText

# 3. Export the Private Key (.key)
Export-PfxCertificate -Cert $cert -FilePath "C:\Program Files\GrafanaLabs\grafana\conf\server.pfx" -Password $pwd

# 4. Convert PFX to PEM (Note: Grafana needs .crt and .key)
# If you don't have OpenSSL installed, you can use the PFX directly in some versions, 
# but standard Grafana config prefers separate files.
```

The cert in cert manager and grafana files.

![cert](https://github.com/spawnmarvel/todo-and-current/blob/main/grafana_loki_alloy/images/certs.png)

Lets make key and pem with openssl.

* https://slproweb.com/products/Win32OpenSSL.html
* Win64 OpenSSL v3.5.6 Light MSI

Install

* C:\Program Files\OpenSSL-Win64
* Copy OpenSSL DLLs to
* * /bin

Excellent choice. Keeping the DLLs in the /bin directory is the "clean" approach. It prevents "DLL Hell"—a situation where other Windows applications might try to use OpenSSL but accidentally load a different version from the System32 folder, causing crashes or security vulnerabilities.

Since you already have a .pfx file (likely from your internal CA or IT department), we just need to use OpenSSL to "split" it into the two separate files Grafana requires.

* Use the password used in the powershell script

```cmd
c:\Program Files\OpenSSL-Win64\bin>openssl -version
OpenSSL 3.5.6 7 Apr 2026 (Library: OpenSSL 3.5.6 7 Apr 2026)

REM Run this to pull the key out. The -nodes flag ensures the resulting key isn't encrypted with a password, which allows Grafana to start up automatically.

openssl pkcs12 -in "C:\Program Files\GrafanaLabs\grafana\conf\server.pfx" -nocerts -out "C:\Program Files\GrafanaLabs\grafana\conf\server.key" -nodes

REM Next, extract the public certificate.
openssl pkcs12 -in "C:\Program Files\GrafanaLabs\grafana\conf\server.pfx" -clcerts -nokeys -out "C:\Program Files\GrafanaLabs\grafana\conf\server.crt"
```

![ssl cert](https://github.com/spawnmarvel/todo-and-current/blob/main/grafana_loki_alloy/images/ssl_certs.png)

Your server.crt should look exactly like this:

```txt
-----BEGIN CERTIFICATE-----
MIIDMzCCAhugAwIBAgIQKDeaPTJyi6pCdXIcGhE3oTANBgkqhkiG9w0BAQsFADAd
... (the rest of your base64 code) ...
3JwCnXO2nA==
-----END CERTIFICATE-----
```

Your server.key should look exactly like this:

```txt
-----BEGIN PRIVATE KEY-----
... (your private key base64 code) ...
-----END PRIVATE KEY-----
```

That "Bag Attributes" text is the metadata OpenSSL includes by default when exporting from a PFX. While humans find it helpful, Grafana's RSA parser usually chokes on it

Grafana is designed to look for a file named custom.ini first. If it finds it, it uses those settings; if a setting isn't there, it falls back to the default.

🔷 Location: C:\Program Files\GrafanaLabs\grafana\conf\custom.ini

🔷 Action: If the file doesn't exist, create it.

🔷 Content: Only put the things you want to change. You don't need to copy the whole file.

Open your custom.ini file. Even though you are on Windows, Grafana prefers forward slashes in its configuration file paths.

```ini
#################################### Server ####################################
[server]
# Protocol (http, https, h2, socket)
protocol = https

# The http port to use
http_port = 3000

# https certs & key file
cert_file = C:/Program Files/GrafanaLabs/grafana/conf/server.crt
cert_key = C:/Program Files/GrafanaLabs/grafana/conf/server.key

```

Optional: stop service , verify custom.ini, start grafana with cmd and check that it loads the custom.ini

```cmd
c:\Program Files\GrafanaLabs\grafana\bin>grafana-server.exe --config="C:\Program Files\GrafanaLabs\grafana\conf\custom.ini"
```

Start grafana service 


🔷 Access: By default, it runs on https://vmhybrid01.lab.local:3000

![secure grafana](https://github.com/spawnmarvel/todo-and-current/blob/main/grafana_loki_alloy/images/secure_grafana.png)


## 2. Loki on Windows
Loki does not have a formal .msi installer yet, but it runs perfectly as a single executable.

🔷 Setup: Download the loki-windows-amd64.exe.zip from the Loki Releases GitHub.

* https://github.com/grafana/loki/releases
* loki-windows-amd64.exe.zip

🔷 Directory: Create a folder at C:\Loki.

🔷 Extract: Place loki-windows-amd64.exe inside that folder.

![loki](https://github.com/spawnmarvel/todo-and-current/blob/main/grafana_loki_alloy/images/loki2.png)

🔷 Configuration: You will need a loki-config.yaml file (you can download the default one here).

* Loki won't run without a config file telling it where to store the log chunks. Create a file at C:\Loki\loki-config.yaml and paste this on-prem friendly config:

```yml
auth_enabled: false

server:
  http_listen_port: 3100
  grpc_listen_port: 9096

common:
  instance_addr: 127.0.0.1
  path_prefix: C:/Loki/data
  storage:
    filesystem:
      chunks_directory: C:/Loki/data/chunks
      rules_directory: C:/Loki/data/rules
  replication_factor: 1
  ring:
    kvstore:
      store: inmemory

schema_config:
  configs:
    - from: 2024-01-01
      store: tsdb
      object_store: filesystem
      schema: v13
      index:
        prefix: index_
        period: 24h
```


Test loki via cmd

```cmd
cd C:\Loki
loki-windows-amd64.exe --config.file=loki-config.yml
```
The log line level=info ... msg="Loki started" confirms the engine is ready to receive logs.

If you see that, press Ctrl+C to stop it.

1. Verification chekc list

🔷 Check readiness: Open your browser and go to http://localhost:3100/ready. It should return the word ready. waith 60 sec

🔷 Check metrics: Go to http://localhost:3100/metrics. You should see a long list of technical data.

### Loki Running as a Service: 

To make it run in the background on your server, most Windows admins use NSSM (Non-Sucking Service Manager) to wrap the .exe into a Windows Service.

🔷 Download NSSM from nssm.cc and put the nssm.exe in C:\Loki or use default folder you unziped

* https://nssm.cc/download

🔷 Open CMD as Administrator and run:

```cmd
C:\Loki\nssm-2.24\nssm-2.24\win64\nssm.exe Install Loki
```

🔷 In the popup window:

Application Tab:

* Path: C:\Loki\loki.exe
* Startup directory: C:\Loki
* Arguments: --config.file=C:\Loki\loki-config.yaml

![nssm](https://github.com/spawnmarvel/todo-and-current/blob/main/grafana_loki_alloy/images/nssm.png)

Details Tab:

* Display name: Loki
* Description: Grafana Loki Log Aggregator
* Startup type: Automatic

🔷 Click Install service.

![install service](https://github.com/spawnmarvel/todo-and-current/blob/main/grafana_loki_alloy/images/install_service.png)

New loki files

![loki files](https://github.com/spawnmarvel/todo-and-current/blob/main/grafana_loki_alloy/images/loki_files.png)

🔷 Start it service

### Connect loki to grafana

![datasource](https://github.com/spawnmarvel/todo-and-current/blob/main/grafana_loki_alloy/images/datasource_loki.png)

## 3. Alloy Agent on Windows (The "Collector")

To actually see your Windows Event Logs (System, Application, Security) inside Grafana, we need to install the Alloy agent. This is what "scrapes" the Windows Event Viewer and pushes the data into Loki.

Download: Get the Alloy Windows MSI installer from the official releases.

* https://github.com/grafana/alloy/releases
* alloy-installer-windows-amd64.exe



Install: Run the MSI on your Windows VM. It will automatically create a service called Grafana Alloy.

* C:\Program Files\GrafanaLabs\Alloy

![alloy install](https://github.com/spawnmarvel/todo-and-current/blob/main/grafana_loki_alloy/images/alloy_install.png)

Configure: * 🔷 Open Notepad as Administrator.

🔷 Open the config file: C:\Program Files\GrafanaLabs\Alloy\config.alloy.

🔷 Replace the contents with this simple "Windows Log Starter" config:

```hcl
logging {
	level = "info"
}

// 1. Tell Alloy to watch Windows Event Logs
loki.source.windowsevent "local_event_logs" {
  locale          = 1033
  eventlog_name   = "System"
  forward_to      = [loki.write.local_loki.receiver]
}

// 2. Tell Alloy where to send them (Your Loki service)
loki.write "local_loki" {
  endpoint {
    url = "http://localhost:3100/loki/api/v1/push"
  }
}
```
🔷 How to See the Results
After you save the file and restart the Alloy service (via services.msc or net stop alloy && net start alloy):

How to see the actual logs now:

![firs logs ](https://github.com/spawnmarvel/todo-and-current/blob/main/grafana_loki_alloy/images/first_logs.png)

🔷 Click on the blue channel button in that Label Browser.

🔷 Click on System (which appeared below it).

🔷 Click the blue Show logs button at the bottom right.

Boom! You should see the live stream of your Windows System logs.



### All files

![all files](https://github.com/spawnmarvel/todo-and-current/blob/main/grafana_loki_alloy/images/all_files.png)

## Add more logs from same server

## Add logs from a different server

* install and configure alloy