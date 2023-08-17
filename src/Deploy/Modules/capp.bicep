// ************************
// Bicep Module File
// Microsoft.App/containerApps
//
// Create Container App
//
// ************************

// Parameters
  @description('The name of the container app')
  param cappName string

  @description('The location to deploy to')
  param location string

  @description('The name of the environment')
  param enviromentName string

  @description('The registry name')
  param acrName string

  @description('The registry key')
  param acrPass string

// Resources
  // Existing Registry
    resource registry 'Microsoft.ContainerRegistry/registries@2022-12-01' existing = {
      name: acrName
    }

  // Create Container App
    resource fspsdsdemoukscapp 'Microsoft.App/containerApps@2023-04-01-preview' = {
      name: cappName
      location: location
      properties: {
        environmentId: managedEnvironmentfspsdsdemouksrgb.id
        configuration: {
          
          secrets: [
            {
              name: 'reg-pswd'
              value: acrPass
            }
          ]
          
          activeRevisionsMode: 'Single'
          ingress: {
            external: true
            targetPort: 80
            exposedPort: 0
            transport: 'Auto'
            traffic: [
              {
                weight: 100
                latestRevision: true
              }
            ]
            allowInsecure: false
          }
          registries: [
            {
              server: '${acrName}.azurecr.io'
              username: registry.listCredentials().username
              passwordSecretRef: 'reg-pswd'
              identity: ''
            }
          ]
        }
        template: {
          revisionSuffix: 'carbon-aware'
          containers: [
            {
              image: '${acrName}.azurecr.io/carbon_aware:v1'
              name: 'carbon-aware'
              resources: {
                cpu: json('0.25')
                memory: '0.5Gi'
              }
              probes: []
            }
          ]
          scale: {
            minReplicas: 0
            maxReplicas: 10
          }
          volumes: []
        }
      }
      identity: {
        type: 'None'
      }
    }

  // Create Managed Environment
    resource managedEnvironmentfspsdsdemouksrgb 'Microsoft.App/managedEnvironments@2023-04-01-preview' = {
      name: enviromentName
      location: location
      properties: {
        zoneRedundant: false
        kedaConfiguration: {}
        daprConfiguration: {}
        customDomainConfiguration: {}
        peerAuthentication: {
          mtls: {
            enabled: false
          }
        }
      }
    }

// Outputs
  output cappurl string = fspsdsdemoukscapp.properties.configuration.ingress.fqdn
