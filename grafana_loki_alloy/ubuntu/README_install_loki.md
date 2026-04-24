# Install Loki on Ubuntu

Installing Loki on Ubuntu using the .deb package is straightforward, but there are a few "extra" steps needed to make it run properly as a system service.

🔷 Step 1: Download and Install the .deb

On your Ubuntu VM, download the Loki package. I recommend version 3.0.0 or higher to ensure you have the latest TSDB features you were using on Windows.

```bash
# Download the package
wget https://github.com/grafana/loki/releases/download/v3.0.0/loki_3.0.0_amd64.deb

# Install using apt (this handles dependencies better than dpkg)
sudo apt install ./loki_3.0.0_amd64.deb

# Note: If dpkg reports "missing dependencies," run sudo apt-get install -f immediately after. 
# This tells Ubuntu to go find any small libraries Loki needs to finish the installation.

sudo dpkg -i loki_3.0.0_amd64.deb
```
