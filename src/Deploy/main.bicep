// ************************
// Main Bicep File
//
// Deployment of resource group, registry 
// and functionapps
//
// ************************

targetScope = 'subscription'

// Parameters
  // Resource Group Parameters
  param resourceGroupName string
  param location string = deployment().location

// Resources
  // Create Resource Group
  resource rg 'Microsoft.Resources/resourceGroups@2022-09-01' ={
    name: resourceGroupName
    location: location
  }

  // Create Registery/Functionapps
  module deployFunctionApps 'deployFunctionApps.bicep' ={
    name: 'firstDeploy'
    params:{
      servicePlanName: 'ASP-sds-${uniqueString(rg.id)}'
      registryName: 'sdsreg${uniqueString(rg.id)}'
      location: rg.location
    }
    scope:rg
  }

// Outputs
  output UKSFunctionAppName string = deployFunctionApps.outputs.UKSFunctionAppName
  output NEUFunctionAppName string = deployFunctionApps.outputs.NEUFunctionAppName
