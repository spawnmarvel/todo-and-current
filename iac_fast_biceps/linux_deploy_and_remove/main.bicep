// Parameters
param location string = 'uksouth'
param vmName string = 'vm-uks-temp-001'
param adminUsername string

@secure()
param adminPassword string

// Variables 
var vmSize = 'Standard_B2s'
var vnetName = 'vnet-uks-central'
var vnetRG = 'Rg-vnet-uks-central'
var subnetName = 'Vms03'
var publicIPName = '${vmName}-pip'
var nicName = '${vmName}-nic'
var nsgName = '${vmName}-nsg' // Added NSG Name

// 1. Reference the VNet
resource vnet 'Microsoft.Network/virtualNetworks@2023-11-01' existing = {
  name: vnetName
  scope: resourceGroup(vnetRG) 
}

// 2. Create the NSG with port 10933 open
resource nsg 'Microsoft.Network/networkSecurityGroups@2023-11-01' = {
  name: nsgName
  location: location
  properties: {
    securityRules: [
      {
        name: 'Allow-10933-Inbound'
        properties: {
          priority: 1000
          access: 'Allow'
          direction: 'Inbound'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '10933'
          sourceAddressPrefix: '*' // Change to your IP for better security
          destinationAddressPrefix: '*'
        }
      }
    ]
  }
}

// 3. Create a Public IP Address
resource publicIP 'Microsoft.Network/publicIPAddresses@2023-11-01' = {
  name: publicIPName
  location: location
  properties: {
    publicIPAllocationMethod: 'Dynamic'
  }
}

// 4. Create the NIC (Now associated with the NSG)
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
    networkSecurityGroup: {
      id: nsg.id // Linking the NSG to the NIC
    }
  }
}

// 5. Create the Virtual Machine
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

// 6. Auto-Shutdown Schedule
resource autoShutdown 'Microsoft.DevTestLab/schedules@2018-09-15' = {
  name: 'shutdown-computevm-${vmName}'
  location: location
  properties: {
    status: 'Enabled'
    taskType: 'ComputeVmShutdownTask'
    dailyRecurrence: {
      time: '0130'
    }
    timeZoneId: 'GMT Standard Time'
    targetResourceId: vm.id
    notificationSettings: {
      status: 'Disabled'
    }
  }
}
