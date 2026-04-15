// Parameters - No default values means you will be prompted
param location string = 'uksouth'
param vmName string = 'vm-uks-temp-001'

param adminUsername string // Prompted

@secure()
param adminPassword string // Prompted securely

// Variables 
var vmSize = 'Standard_B2s'
var vnetName = 'vnet-uks-central'
var vnetRG = 'Rg-vnet-uks-central'
var subnetName = 'Vms03'
var publicIPName = '${vmName}-pip'
var nicName = '${vmName}-nic'

// 1. Reference the VNet in the Networking Resource Group
resource vnet 'Microsoft.Network/virtualNetworks@2023-11-01' existing = {
  name: vnetName
  scope: resourceGroup(vnetRG) 
}

// 2. Create a Public IP Address
resource publicIP 'Microsoft.Network/publicIPAddresses@2023-11-01' = {
  name: publicIPName
  location: location
  properties: {
    publicIPAllocationMethod: 'Dynamic'
  }
}

// 3. Create the NIC
resource nic 'Microsoft.Network/networkInterfaces@2023-11-01' = {
  name: nicName
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIP.id
          }
          subnet: {
            id: '${vnet.id}/subnets/${subnetName}'
          }
        }
      }
    ]
  }
}

// 4. Create the Virtual Machine
resource vm 'Microsoft.Compute/virtualMachines@2024-03-01' = {
  name: vmName
  location: location
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    osProfile: {
      computerName: vmName
      adminUsername: adminUsername
      adminPassword: adminPassword
      linuxConfiguration: {
        disablePasswordAuthentication: false
      }
    }
    storageProfile: {
      imageReference: {
        publisher: 'Canonical'
        offer: 'ubuntu-24_04-lts'
        sku: 'server'
        version: 'latest'
      }
      osDisk: {
        name: '${vmName}-osdisk'
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: 'StandardSSD_LRS'
        }
        diskSizeGB: 30
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nic.id
        }
      ]
    }
  }
}

// 5. Auto-Shutdown Schedule at 01:30
resource autoShutdown 'Microsoft.DevTestLab/schedules@2018-09-15' = {
  name: 'shutdown-computevm-${vmName}'
  location: location
  properties: {
    status: 'Enabled'
    taskType: 'ComputeVmShutdownTask'
    dailyRecurrence: {
      time: '0130' // 01:30 AM
    }
    timeZoneId: 'GMT Standard Time' // Matches UK South location
    targetResourceId: vm.id
    notificationSettings: {
      status: 'Disabled' // Set to 'Enabled' if you want email alerts before shutdown
    }
  }
}
