// ************************
// Bicep Deploy File
//
//
// Create Apim and Capp
//
// ************************

// Parameters
  // Standard Parameters
    @description('Location to deploy to')
    param location string = resourceGroup().location

  // FunctionApp Reference Parameters
    @description('Name of NEU functionApp')
    param sdsFunctionAppNameNEU string = 'sds-demo-neu-${uniqueString(resourceGroup().id)}'

    @description('Name of UKS functionApp')
    param sdsFunctionAppNameUKS string = 'sds-demo-uks-${uniqueString(resourceGroup().id)}'

    @description('Key for NEU functionApp')
    param functionNeupass string

    @description('Key for UKS functionApp')
    param functionUkspass string
  
  // Registry Reference Parameters
    @description('Registry name')
    param acrName string 
    
    @description('Registry key')
    param acrpass string


  // APIM Parameters
    @description('Apim Name')
    param apimName string = 'sds-apim-${uniqueString(resourceGroup().id)}'

    @description('Publisher name')
    param pubName string

    @description('Publisher email')
    param adminEmail string

  // Container App Parameters
    @description('Capp name')
    param containerAppName string = 'sds-capp-${uniqueString(resourceGroup().id)}'

    @description('Environment name')
    param environmentName string = 'sds-capp-environment-${uniqueString(resourceGroup().id)}'

//Modules
  // Apim
  module apim '../Deploy/Modules/apim.bicep' = {
    name: 'apim'
    params: {
      apimName: apimName
      location: location
      cappUrl: containerApp.outputs.cappurl
      pubName: pubName
      adminEmail: adminEmail
      neupass: functionNeupass
      uksPass: functionUkspass
      functionNameNeu: sdsFunctionAppNameNEU
      functionNameUks: sdsFunctionAppNameUKS
    }
  }

  // Container App
  module containerApp '../Deploy/Modules/capp.bicep' = {
    name: 'containerApp'
    params: {
      cappName: containerAppName
      location: location
      enviromentName: environmentName
      acrName: acrName
      acrPass: acrpass
    }
  }

// Outputs
  output apimUrl string = apim.outputs.apimUrl
  output cappUrl string = containerApp.outputs.cappurl
