// ************************
// Bicep Deploy File
//
//
// Create functionApps and registry
//
// ************************

//Parameters
  // Standard Parameters
    @description('location to deploy to')
    param location string

  // Storage Group Params
    param storageAccountLocations array = [
      'northeurope'
      'uksouth'
    ]

  // Function App Parameters
    param functionAppNames array = [
      'sds-demo-neu-${uniqueString(resourceGroup().id)}'
      'sds-demo-uks-${uniqueString(resourceGroup().id)}'
    ]

    @description('App service plan name')
    param servicePlanName string

  //Registry Parameters
    @description('Registry Name')
    param registryName string


//Modules
  // Storage Account
    module storageAccount '../Deploy/Modules/storageAccount.bicep' = [for storageLocation in storageAccountLocations: {
      name: 'functionAppStorageAccount_${storageLocation}'
      params: {
        storageAccount_name: '${storageLocation}${uniqueString(resourceGroup().id)}'
        location: storageLocation
      }
    }]

  // Function Apps
    module functionApp '../Deploy/Modules/function.bicep' = [for i in range(0, 2): {
      name: 'Function${storageAccountLocations[i]}'
      params: {
        functionAppName: functionAppNames[i]
        location: storageAccountLocations[i]
        appServicePlanName: '${storageAccountLocations[i]}-${servicePlanName}'
        storageAccontName: storageAccount[i].outputs.name
      }
    }]

  // Registry
    module storageUKS '../Deploy/Modules/registry.bicep' = {
      name: 'StorageUKS'
      params: {
        registryName: registryName
        location: location
      }
    }

// Outputs
  output NEUFunctionAppName string = functionAppNames[0]
  output UKSFunctionAppName string = functionAppNames[1]
