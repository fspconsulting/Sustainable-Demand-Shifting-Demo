// ************************
// Bicep Module File
// Microsoft.ApiManagement
//
// Create APIM
//
// ************************

// Parameters
  @description('The name of the APIM')
  param apimName string

  @description('The location to deploy to')
  param location string

  @description('The Container App Url')
  param cappUrl string

  @description('The name of the publisher')
  param pubName string

  @description('The publishers email')
  param adminEmail string

  @description('The NEU function key')
  param neupass string

  @description('The UKS function key')
  param uksPass string

  @description('The UKS function name')
  param functionNameUks string

  @description('The NEU function name')
  param functionNameNeu string

// Resources  
  // Create APIM Services
    resource service_fsp_sds_demo_uks_apim_name_resource 'Microsoft.ApiManagement/service@2023-03-01-preview' = {
      name: apimName
      location: location
      sku: {
        name: 'Consumption'
        capacity: 0
      }
      properties: {
        publisherEmail: adminEmail
        publisherName: pubName
        notificationSenderEmail: 'apimgmt-noreply@mail.windowsazure.com'
        hostnameConfigurations: [
          {
            type: 'Proxy'
            hostName: '${apimName}.azure-api.net'
            negotiateClientCertificate: false
            defaultSslBinding: true
            certificateSource: 'BuiltIn'
          }
        ]
        customProperties: {
          'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Protocols.Tls11': 'false'
          'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Protocols.Tls10': 'false'
          'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Backend.Protocols.Tls11': 'false'
          'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Backend.Protocols.Tls10': 'false'
          'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Backend.Protocols.Ssl30': 'false'
          'Microsoft.WindowsAzure.ApiManagement.Gateway.Protocols.Server.Http2': 'false'
        }
        virtualNetworkType: 'None'
        disableGateway: false
        natGatewayState: 'Disabled'
        apiVersionConstraint: {}
        publicNetworkAccess: 'Enabled'
        legacyPortalStatus: 'Enabled'
        developerPortalStatus: 'Enabled'
      }
    }

  // Create APIM Version Set
    resource Microsoft_ApiManagement_service_apiVersionSets_service_fsp_sds_demo_uks_apim_name_648385740e9087ceae25f9de 'Microsoft.ApiManagement/service/apiVersionSets@2023-03-01-preview' = {
      parent: service_fsp_sds_demo_uks_apim_name_resource
      name: '648385740e9087ceae25f9de1'
      properties: {
        displayName: 'SDS Demo API'
        versioningScheme: 'Segment'
      }
    }

  // Create APIM Backends
    resource service_fsp_sds_demo_uks_apim_name_DoWorkFunctionNEU 'Microsoft.ApiManagement/service/backends@2023-03-01-preview' = {
      parent: service_fsp_sds_demo_uks_apim_name_resource
      name: 'DoWorkFunctionNEU'
      properties: {
        url: 'https://${functionNameNeu}.azurewebsites.net/api/DoWork'
        protocol: 'http'
        credentials: {
          query: {
            code: [
              '{{DoWorkFunctionNEUKey}}'
            ]
          }
          header: {}
        }
        tls: {
          validateCertificateChain: true
          validateCertificateName: true
        }
      }
    }

  resource service_fsp_sds_demo_uks_apim_name_DoWorkFunctionUKS 'Microsoft.ApiManagement/service/backends@2023-03-01-preview' = {
    parent: service_fsp_sds_demo_uks_apim_name_resource
    name: 'DoWorkFunctionUKS'
    properties: {
      url: 'https://${functionNameUks}.azurewebsites.net/api/DoWork'
      protocol: 'http'
      credentials: {
        query: {
          code: [
            '{{DoWorkFunctionUKSKey}}'
          ]
        }
        header: {}
      }
      tls: {
        validateCertificateChain: true
        validateCertificateName: true
      }
    }
  }

  // Create APIM Service Properties
    resource Microsoft_ApiManagement_service_properties_service_fsp_sds_demo_uks_apim_name_DoWorkFunctionNEUKey 'Microsoft.ApiManagement/service/properties@2019-01-01' = {
      parent: service_fsp_sds_demo_uks_apim_name_resource
      name: 'DoWorkFunctionNEUKey'
      properties: {
        displayName: 'DoWorkFunctionNEUKey'
        value: neupass
        tags: []
        secret: true
      }
    }

    resource Microsoft_ApiManagement_service_properties_service_fsp_sds_demo_uks_apim_name_DoWorkFunctionUKSKey 'Microsoft.ApiManagement/service/properties@2019-01-01' = {
      parent: service_fsp_sds_demo_uks_apim_name_resource
      name: 'DoWorkFunctionUKSKey'
      properties: {
        displayName: 'DoWorkFunctionUKSKey'
        value: uksPass
        tags: []
        secret: true
      }
    }

    resource Microsoft_ApiManagement_service_properties_service_fsp_sds_demo_uks_apim_name_EmissionsEndpoint 'Microsoft.ApiManagement/service/properties@2019-01-01' = {
      parent: service_fsp_sds_demo_uks_apim_name_resource
      name: 'EmissionsEndpoint'
      properties: {
        displayName: 'EmissionsEndpoint'
        value: 'https://${cappUrl}/emissions/bylocations/best?location=GB&location=IE'
        tags: []
        secret: false
      }
    }

  // Create API
    resource service_fsp_sds_demo_uks_apim_name_sds_demo_api 'Microsoft.ApiManagement/service/apis@2023-03-01-preview' = {
      parent: service_fsp_sds_demo_uks_apim_name_resource
      name: 'sds-demo-api'
      properties: {
        displayName: 'SDS Demo API'
        apiRevision: '1'
        subscriptionRequired: false
        path: 'sds-demo'
        protocols: [
          'https'
        ]
        authenticationSettings: {
          oAuth2AuthenticationSettings: []
          openidAuthenticationSettings: []
        }
        subscriptionKeyParameterNames: {
          header: 'Ocp-Apim-Subscription-Key'
          query: 'subscription-key'
        }
        isCurrent: true
        apiVersion: 'v1.0'
        apiVersionSetId: Microsoft_ApiManagement_service_apiVersionSets_service_fsp_sds_demo_uks_apim_name_648385740e9087ceae25f9de.id
      }
    }

  // Create APIM Operations
    resource service_fsp_sds_demo_uks_apim_name_sds_demo_api_6484470943d08232b8a58931 'Microsoft.ApiManagement/service/apis/operations@2023-03-01-preview' = {
      parent: service_fsp_sds_demo_uks_apim_name_sds_demo_api
      name: '6484470943d08232b8a58931'
      properties: {
        displayName: 'DoWorkUKS'
        method: 'GET'
        urlTemplate: '/doworkuks'
        templateParameters: []
        responses: []
      }
    }

    resource service_fsp_sds_demo_uks_apim_name_sds_demo_api_6484474b87c5a05791c2f1ea 'Microsoft.ApiManagement/service/apis/operations@2023-03-01-preview' = {
      parent: service_fsp_sds_demo_uks_apim_name_sds_demo_api
      name: '6484474b87c5a05791c2f1ea'
      properties: {
        displayName: 'DoWorkNEU'
        method: 'GET'
        urlTemplate: '/doworkneu'
        templateParameters: []
        responses: []
      }
    }

    resource service_fsp_sds_demo_uks_apim_name_sds_demo_api_dowork 'Microsoft.ApiManagement/service/apis/operations@2023-03-01-preview' = {
      parent: service_fsp_sds_demo_uks_apim_name_sds_demo_api
      name: 'dowork'
      properties: {
        displayName: 'DoWork'
        method: 'GET'
        urlTemplate: '/dowork'
        templateParameters: []
        responses: []
      }
    }

  // Create APIM Policies
    resource service_fsp_sds_demo_uks_apim_name_policy 'Microsoft.ApiManagement/service/policies@2023-03-01-preview' = {
      parent: service_fsp_sds_demo_uks_apim_name_resource
      name: 'policy'
      properties: {
        value: '<!--\r\n    IMPORTANT:\r\n    - Policy elements can appear only within the <inbound>, <outbound>, <backend> section elements.\r\n    - Only the <forward-request> policy element can appear within the <backend> section element.\r\n    - To apply a policy to the incoming request (before it is forwarded to the backend service), place a corresponding policy element within the <inbound> section element.\r\n    - To apply a policy to the outgoing response (before it is sent back to the caller), place a corresponding policy element within the <outbound> section element.\r\n    - To add a policy position the cursor at the desired insertion point and click on the round button associated with the policy.\r\n    - To remove a policy, delete the corresponding policy statement from the policy document.\r\n    - Policies are applied in the order of their appearance, from the top down.\r\n-->\r\n<policies>\r\n  <inbound></inbound>\r\n  <backend>\r\n    <forward-request />\r\n  </backend>\r\n  <outbound></outbound>\r\n</policies>'
        format: 'xml'
      }
    }

    resource service_fsp_sds_demo_uks_apim_name_sds_demo_api_policy 'Microsoft.ApiManagement/service/apis/policies@2023-03-01-preview' = {
      parent: service_fsp_sds_demo_uks_apim_name_sds_demo_api
      name: 'policy'
      properties: {
        value: '<!--\r\n    IMPORTANT:\r\n    - Policy elements can appear only within the <inbound>, <outbound>, <backend> section elements.\r\n    - To apply a policy to the incoming request (before it is forwarded to the backend service), place a corresponding policy element within the <inbound> section element.\r\n    - To apply a policy to the outgoing response (before it is sent back to the caller), place a corresponding policy element within the <outbound> section element.\r\n    - To add a policy, place the cursor at the desired insertion point and select a policy from the sidebar.\r\n    - To remove a policy, delete the corresponding policy statement from the policy document.\r\n    - Position the <base> element within a section element to inherit all policies from the corresponding section element in the enclosing scope.\r\n    - Remove the <base> element to prevent inheriting policies from the corresponding section element in the enclosing scope.\r\n    - Policies are applied in the order of their appearance, from the top down.\r\n    - Comments within policy elements are not supported and may disappear. Place your comments between policy elements or at a higher level scope.\r\n-->\r\n<policies>\r\n  <inbound>\r\n    <base />\r\n  </inbound>\r\n  <backend>\r\n    <base />\r\n  </backend>\r\n  <outbound>\r\n    <base />\r\n  </outbound>\r\n  <on-error>\r\n    <base />\r\n  </on-error>\r\n</policies>'
        format: 'xml'
      }
    }

    resource service_fsp_sds_demo_uks_apim_name_sds_demo_api_6484470943d08232b8a58931_policy 'Microsoft.ApiManagement/service/apis/operations/policies@2023-03-01-preview' = {
      parent: service_fsp_sds_demo_uks_apim_name_sds_demo_api_6484470943d08232b8a58931
      name: 'policy'
      properties: {
        value: '<!--\r\n    IMPORTANT:\r\n    - Policy elements can appear only within the <inbound>, <outbound>, <backend> section elements.\r\n    - To apply a policy to the incoming request (before it is forwarded to the backend service), place a corresponding policy element within the <inbound> section element.\r\n    - To apply a policy to the outgoing response (before it is sent back to the caller), place a corresponding policy element within the <outbound> section element.\r\n    - To add a policy, place the cursor at the desired insertion point and select a policy from the sidebar.\r\n    - To remove a policy, delete the corresponding policy statement from the policy document.\r\n    - Position the <base> element within a section element to inherit all policies from the corresponding section element in the enclosing scope.\r\n    - Remove the <base> element to prevent inheriting policies from the corresponding section element in the enclosing scope.\r\n    - Policies are applied in the order of their appearance, from the top down.\r\n    - Comments within policy elements are not supported and may disappear. Place your comments between policy elements or at a higher level scope.\r\n-->\r\n<policies>\r\n  <inbound>\r\n    <base />\r\n    <set-backend-service backend-id="DoWorkFunctionUKS" />\r\n    <rewrite-uri template="/" copy-unmatched-params="false" />\r\n  </inbound>\r\n  <backend>\r\n    <base />\r\n  </backend>\r\n  <outbound>\r\n    <base />\r\n  </outbound>\r\n  <on-error>\r\n    <base />\r\n  </on-error>\r\n</policies>'
        format: 'xml'
      }
    }

    resource service_fsp_sds_demo_uks_apim_name_sds_demo_api_6484474b87c5a05791c2f1ea_policy 'Microsoft.ApiManagement/service/apis/operations/policies@2023-03-01-preview' = {
      parent: service_fsp_sds_demo_uks_apim_name_sds_demo_api_6484474b87c5a05791c2f1ea
      name: 'policy'
      properties: {
        value: '<!--\r\n    IMPORTANT:\r\n    - Policy elements can appear only within the <inbound>, <outbound>, <backend> section elements.\r\n    - To apply a policy to the incoming request (before it is forwarded to the backend service), place a corresponding policy element within the <inbound> section element.\r\n    - To apply a policy to the outgoing response (before it is sent back to the caller), place a corresponding policy element within the <outbound> section element.\r\n    - To add a policy, place the cursor at the desired insertion point and select a policy from the sidebar.\r\n    - To remove a policy, delete the corresponding policy statement from the policy document.\r\n    - Position the <base> element within a section element to inherit all policies from the corresponding section element in the enclosing scope.\r\n    - Remove the <base> element to prevent inheriting policies from the corresponding section element in the enclosing scope.\r\n    - Policies are applied in the order of their appearance, from the top down.\r\n    - Comments within policy elements are not supported and may disappear. Place your comments between policy elements or at a higher level scope.\r\n-->\r\n<policies>\r\n  <inbound>\r\n    <base />\r\n    <set-backend-service backend-id="DoWorkFunctionNEU" />\r\n    <rewrite-uri template="/" copy-unmatched-params="false" />\r\n  </inbound>\r\n  <backend>\r\n    <base />\r\n  </backend>\r\n  <outbound>\r\n    <base />\r\n  </outbound>\r\n  <on-error>\r\n    <base />\r\n  </on-error>\r\n</policies>'
        format: 'xml'
      }
    }

    resource service_fsp_sds_demo_uks_apim_name_sds_demo_api_dowork_policy 'Microsoft.ApiManagement/service/apis/operations/policies@2023-03-01-preview' = {
      parent: service_fsp_sds_demo_uks_apim_name_sds_demo_api_dowork
      name: 'policy'
      properties: {
        value: '<!--\r\n    IMPORTANT:\r\n    - Policy elements can appear only within the <inbound>, <outbound>, <backend> section elements.\r\n    - To apply a policy to the incoming request (before it is forwarded to the backend service), place a corresponding policy element within the <inbound> section element.\r\n    - To apply a policy to the outgoing response (before it is sent back to the caller), place a corresponding policy element within the <outbound> section element.\r\n    - To add a policy, place the cursor at the desired insertion point and select a policy from the sidebar.\r\n    - To remove a policy, delete the corresponding policy statement from the policy document.\r\n    - Position the <base> element within a section element to inherit all policies from the corresponding section element in the enclosing scope.\r\n    - Remove the <base> element to prevent inheriting policies from the corresponding section element in the enclosing scope.\r\n    - Policies are applied in the order of their appearance, from the top down.\r\n    - Comments within policy elements are not supported and may disappear. Place your comments between policy elements or at a higher level scope.\r\n-->\r\n<policies>\r\n  <inbound>\r\n    <base />\r\n    <choose>\r\n      <when condition="@(context.Request.Headers.ContainsKey(&quot;x-fsp-location&quot;))">\r\n        <set-variable name="preferredLocation" value="@(context.Request.Headers.GetValueOrDefault(&quot;x-fsp-location&quot;))" />\r\n      </when>\r\n      <otherwise>\r\n        <send-request mode="new" response-variable-name="emissionsResponse" timeout="60" ignore-error="true">\r\n          <set-url>{{EmissionsEndpoint}}</set-url>\r\n          <set-method>GET</set-method>\r\n        </send-request>\r\n        <set-variable name="bestLocation" value="@(context.Variables.GetValueOrDefault&lt;IResponse&gt;(&quot;emissionsResponse&quot;).Body.As&lt;JArray&gt;().FirstOrDefault())" />\r\n        <set-variable name="preferredLocation" value="@((context.Variables.GetValueOrDefault&lt;JObject&gt;(&quot;bestLocation&quot;)?[&quot;location&quot;] ?? &quot;&quot;).ToString())" />\r\n      </otherwise>\r\n    </choose>\r\n    <choose>\r\n      <when condition="@(context.Variables.GetValueOrDefault&lt;string&gt;(&quot;preferredLocation&quot;).Equals(&quot;IE&quot;, StringComparison.OrdinalIgnoreCase))">\r\n        <set-backend-service backend-id="DoWorkFunctionNEU" />\r\n      </when>\r\n      <otherwise>\r\n        <set-backend-service backend-id="DoWorkFunctionUKS" />\r\n      </otherwise>\r\n    </choose>\r\n    <rewrite-uri template="/" copy-unmatched-params="false" />\r\n  </inbound>\r\n  <backend>\r\n    <base />\r\n  </backend>\r\n  <outbound>\r\n    <base />\r\n  </outbound>\r\n  <on-error>\r\n    <base />\r\n  </on-error>\r\n</policies>'
        format: 'xml'
      }
    }

// Outputs
  output apimUrl string = service_fsp_sds_demo_uks_apim_name_resource.properties.gatewayUrl
