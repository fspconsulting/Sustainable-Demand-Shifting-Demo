// ************************
// Bicep Module File
// Microsoft.Storage/storageAccounts
//
// Create Storage Account
//
// ************************

// Paramters
  @description('The location to deploy to')
  param location string

  @description('The storage account name')
  param storageAccount_name string

// Resources   
  // Create Storage Account
    resource storageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' = {
      name: storageAccount_name
      location: location
      sku: {
        name: 'Standard_LRS'
      }
      kind: 'Storage'
      properties: {
        defaultToOAuthAuthentication: true
        minimumTlsVersion: 'TLS1_2'
        allowBlobPublicAccess: true
        networkAcls: {
          bypass: 'AzureServices'
          virtualNetworkRules: []
          ipRules: []
          defaultAction: 'Allow'
        }
        supportsHttpsTrafficOnly: true
        encryption: {
          services: {
            file: {
              keyType: 'Account'
              enabled: true
            }
            blob: {
              keyType: 'Account'
              enabled: true
            }
          }
          keySource: 'Microsoft.Storage'
        }
      }
    }

//outputs
  output name string = storageAccount.name
  output id string = storageAccount.id
