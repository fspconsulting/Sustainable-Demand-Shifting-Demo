// ************************
// Bicep Module File
// Microsoft.Web/sites
//
// Create a Function App
//
// ************************

// Parameters
  @description('The name of the function app')
  param functionAppName string

  @description('The name of the service plan')
  param appServicePlanName string

  @description('The location to deploy to')
  param location string

  @description('Name of the existing storage account')
  param storageAccontName string

// Resources
  // Reference existing StorageAccount
    resource storageAccounts_resource 'Microsoft.Storage/storageAccounts@2022-09-01' existing = {
      name: storageAccontName
    }

  // Create Server Farm
    resource serverFarm 'Microsoft.Web/serverfarms@2022-03-01' = {
      name: appServicePlanName
      location: location
      sku: {
        name: 'Y1'
        tier: 'Dynamic'
        size: 'Y1'
        family: 'Y'
        capacity: 0
    }
    kind: 'functionapp'
    properties: {
        perSiteScaling: false
        elasticScaleEnabled: false
        maximumElasticWorkerCount: 1
        isSpot: false
        reserved: false
        isXenon: false
        hyperV: false
        targetWorkerCount: 0
        targetWorkerSizeId: 0
        zoneRedundant: false
      }
    }

  // Create Function App
    resource functionAppName_resource 'Microsoft.Web/sites@2022-09-01' = {
      name: functionAppName
      location: location
      kind: 'functionapp'
      properties: {
        enabled: true
        hostNameSslStates: [
          {
            name: '${functionAppName}.azurewebsites.net'
            sslState: 'Disabled'
            hostType: 'Standard'
          }
          {
            name: '${functionAppName}.scm.azurewebsites.net'
            sslState: 'Disabled'
            hostType: 'Repository'
          }
        ]
        serverFarmId: serverFarm.id
        reserved: false
        isXenon: false
        hyperV: false
        vnetRouteAllEnabled: false
        vnetImagePullEnabled: false
        vnetContentShareEnabled: false
        siteConfig: {
          appSettings:[
            {
              name: 'AzureWebJobsStorage'
              value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccounts_resource.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${storageAccounts_resource.listKeys().keys[0].value}'
            }
            {
              name: 'WEBSITE_CONTENTAZUREFILECONNECTIONSTRING'
              value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccounts_resource.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${storageAccounts_resource.listKeys().keys[0].value}'
            } 
            {
              name: 'WEBSITE_CONTENTSHARE'
              value: functionAppName
            }
          ]
          numberOfWorkers: 1
          acrUseManagedIdentityCreds: false
          alwaysOn: false
          http20Enabled: false
          functionAppScaleLimit: 200
          minimumElasticInstanceCount: 0
        }
        scmSiteAlsoStopped: false
        clientAffinityEnabled: false
        clientCertEnabled: false
        clientCertMode: 'Required'
        hostNamesDisabled: false
        customDomainVerificationId: '074B93B2DFD1B0815E61B680F3A09A45DD5B12920DBA5FC3E8ED5B96781CBC22'
        containerSize: 1536
        dailyMemoryTimeQuota: 0
        httpsOnly: true
        redundancyMode: 'None'
        publicNetworkAccess: 'Enabled'
        storageAccountRequired: false
        keyVaultReferenceIdentity: 'SystemAssigned'
      }
    }

  // Create Credential Policies
    resource functionAppName_ftp 'Microsoft.Web/sites/basicPublishingCredentialsPolicies@2022-09-01' = {
      parent: functionAppName_resource
      name: 'ftp'
      properties: {
        allow: true
      }
    }

    resource functionAppName_scm 'Microsoft.Web/sites/basicPublishingCredentialsPolicies@2022-09-01' = {
      parent: functionAppName_resource
      name: 'scm'
      properties: {
        allow: true
      }
    }

  // Create Site Config
    resource functionAppName_web 'Microsoft.Web/sites/config@2022-09-01' = {
      parent: functionAppName_resource
      name: 'web'
      properties: {
        numberOfWorkers: 1
        defaultDocuments: [
          'Default.htm'
          'Default.html'
          'Default.asp'
          'index.htm'
          'index.html'
          'iisstart.htm'
          'default.aspx'
          'index.php'
        ]
        netFrameworkVersion: 'v7.0'
        requestTracingEnabled: false
        remoteDebuggingEnabled: false
        httpLoggingEnabled: false
        acrUseManagedIdentityCreds: false
        logsDirectorySizeLimit: 35
        detailedErrorLoggingEnabled: false
        publishingUsername: functionAppName
        scmType: 'None'
        use32BitWorkerProcess: true
        webSocketsEnabled: false
        alwaysOn: false
        managedPipelineMode: 'Integrated'
        virtualApplications: [
          {
            virtualPath: '/'
            physicalPath: 'site\\wwwroot'
            preloadEnabled: false
          }
        ]
        loadBalancing: 'LeastRequests'
        experiments: {
          rampUpRules: []
        }
        autoHealEnabled: false
        vnetRouteAllEnabled: false
        vnetPrivatePortsCount: 0
        publicNetworkAccess: 'Enabled'
        cors: {
          allowedOrigins: [
            'https://portal.azure.com'
          ]
          supportCredentials: false
        }
        localMySqlEnabled: false
        ipSecurityRestrictions: [
          {
            ipAddress: 'Any'
            action: 'Allow'
            priority: 2147483647
            name: 'Allow all'
            description: 'Allow all access'
          }
        ]
        scmIpSecurityRestrictions: [
          {
            ipAddress: 'Any'
            action: 'Allow'
            priority: 2147483647
            name: 'Allow all'
            description: 'Allow all access'
          }
        ]
        scmIpSecurityRestrictionsUseMain: false
        http20Enabled: false
        minTlsVersion: '1.2'
        scmMinTlsVersion: '1.2'
        ftpsState: 'FtpsOnly'
        preWarmedInstanceCount: 0
        functionAppScaleLimit: 200
        functionsRuntimeScaleMonitoringEnabled: false
        minimumElasticInstanceCount: 0
        azureStorageAccounts: {}
      }
    }

  // Create Host Name Bindings
    resource functionAppName_azurewebsites_net 'Microsoft.Web/sites/hostNameBindings@2022-09-01' = {
      parent: functionAppName_resource
      name: '${functionAppName}.azurewebsites.net'
      properties: {
        siteName: functionAppName
        hostNameType: 'Verified'
      }
    }
