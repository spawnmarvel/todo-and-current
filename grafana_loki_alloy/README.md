# Grafana, Loki and Allow

## Filebeat, Elastic Search and Kibana

We tested that, it is ok, but Kibana has some extra clutter and very big gui.

https://github.com/spawnmarvel/linux-and-azure/tree/main/azure-extra-linux-vm/kibana-elasticsearch-file-beat


Lets test a simpler stack

## Test it in Windows

### 1. Grafana on Windows
Grafana provides a standard Windows installer (.msi) or a standalone .zip file.

🔷 Installation: Download the installer from the official Grafana download page.

🔷 Service: It installs as a Windows Service automatically, meaning it will start whenever the server reboots.

🔷 Access: By default, it runs on http://localhost:3000.

### 2. Loki on Windows
Loki does not have a formal .msi installer yet, but it runs perfectly as a single executable.

🔷 Setup: Download the loki-windows-amd64.exe.zip from the Loki Releases GitHub.

Grafana OSS

* https://grafana.com/grafana/download/12.4.0?edition=oss&platform=windows


🔷 Configuration: You will need a loki-config.yaml file (you can download the default one here).

🔷 Running as a Service: To make it run in the background on your server, most Windows admins use NSSM (Non-Sucking Service Manager) to wrap the .exe into a Windows Service.

### 3. Alloy Agent on Windows (The "Collector")

This is where the Windows setup shines. Alloy has a dedicated Windows installer that sets everything up for you.

🔷 Installation: Download the alloy-installer-windows-amd64.exe from the Alloy GitHub.

🔷 Windows Event Logs: Unlike Filebeat, which requires extra modules, Alloy has a built-in component called loki.relabel and loki.source.windowsevent that can pull directly from Application, System, and Security event logs.

🔷 Config Location: After installation, your configuration lives at:
C:\Program Files\GrafanaLabs\Alloy\config.alloy

## Example Alloy Config for Windows

```hcl
// 1. Collect Windows Event Logs (System & Application)
loki.source.windowsevent "event_viewer" {
  eventlog_name = "System,Application"
  forward_to    = [loki.write.local_loki.receiver]
}

// 2. Collect a specific App Log File
local.file_match "app_logs" {
  path_targets = [{"__path__" = "C:\\Logs\\*.log"}]
}

loki.source.file "local_files" {
  targets    = local.file_match.app_logs.targets
  forward_to = [loki.write.local_loki.receiver]
}

// 3. Push everything to your Loki Server
loki.write "local_loki" {
  endpoint {
    url = "http://<YOUR_LOKI_IP>:3100/loki/api/v1/push"
  }
}
```