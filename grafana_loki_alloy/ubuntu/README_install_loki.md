# Install Loki on Ubuntu

Installing Loki on Ubuntu using the .deb package is straightforward, but there are a few "extra" steps needed to make it run properly as a system service.

## Install Loki

🔷 Step get the grafana repos

Since Loki is part of the Grafana ecosystem, it is hosted in the same official Grafana APT repository. You only need to add the repository once to install both grafana and loki.

Grafana Alloy is part of the same official Grafana APT repository

How to Grafana with apt

Grafana OSS	grafana	https://apt.grafana.com stable main

```bash
# 1. Install the prerequisite packages:
sudo apt-get install -y apt-transport-https wget gnupg

# 2 Import the GPG key:
sudo mkdir -p /etc/apt/keyrings
sudo wget -O /etc/apt/keyrings/grafana.asc https://apt.grafana.com/gpg-full.key
sudo chmod 644 /etc/apt/keyrings/grafana.asc

# 3 To add a repository for stable releases, run the following command:
echo "deb [signed-by=/etc/apt/keyrings/grafana.asc] https://apt.grafana.com stable main" | sudo tee -a /etc/apt/sources.list.d/grafana.list

# 4 Run the following command to update the list of available packages
# Updates the list of available packages
sudo apt-get update

# 5 To install Grafana OSS, run the following command:
# Installs the latest OSS release, only if you are running Grafana
# sudo apt-get install grafana
```
- https://grafana.com/docs/grafana/latest/setup-grafana/installation/debian/


🔷 Step How to loki with apt 

- https://grafana.com/docs/loki/latest/setup/install/local/

Add the Grafana Advanced Package Tool (APT) or RPM Package Manager (RPM) package repository following the linked instructions.
We already did that in the Grafana apt step 1, 2 and 3

```bash
sudo apt update

sudo apt install loki

```
🔷 Step How to dpkg: Download and Install the .deb

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

## Configure Loki


## Install and configure Alloy agent

Since Loki is part of the Grafana ecosystem, it is hosted in the same official Grafana APT repository. You only need to add the repository once to install both grafana and loki.

Grafana Alloy is part of the same official Grafana APT repository.


## Use Logql to query data


