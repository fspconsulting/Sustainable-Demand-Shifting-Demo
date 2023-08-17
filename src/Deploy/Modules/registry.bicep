// ************************
// Bicep Module File
// Microsoft.ContainerRegistry/registries
//
// Create a Registry
//
// ************************

// Parameters
  @description('The name of the registry')
  param registryName string
  
  @description('The location to deploy to')
  param location string

// Resources
  // Create Registry
    resource fspsdsdemoukscr 'Microsoft.ContainerRegistry/registries@2023-01-01-preview' = {
    sku: {
      name: 'Basic'
    }
    name: registryName
    location: location
    tags: {}
    properties: {
      adminUserEnabled: true
      policies: {
        quarantinePolicy: {
          status: 'disabled'
        }
        trustPolicy: {
          type: 'Notary'
          status: 'disabled'
        }
        retentionPolicy: {
          days: 7
          status: 'disabled'
        }
        exportPolicy: {
          status: 'enabled'
        }
        azureADAuthenticationAsArmPolicy: {
          status: 'enabled'
        }
        softDeletePolicy: {
          retentionDays: 7
          status: 'disabled'
        }
      }
      encryption: {
        status: 'disabled'
      }
      dataEndpointEnabled: false
      publicNetworkAccess: 'Enabled'
      networkRuleBypassOptions: 'AzureServices'
      zoneRedundancy: 'Disabled'
      anonymousPullEnabled: false
    }
  }
