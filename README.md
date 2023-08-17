# Sustainable Demand Shifting Demo
---
This demo was inspired by the [Carbon Aware SDK](https://github.com/Green-Software-Foundation/carbon-aware-sdk) created by the [Green Software Foundation](https://greensoftware.foundation/)
and illustrates sustainable demand shifting.

## Introduction
---
Sustainability is about meeting the needs of the present – without compromising the ability of future generations to meet their needs. Organisations have a responsibility to transform the way they use digital technology to be more sustainable. As software engineers, we have a responsibility to ensure minimise the carbon footprint of the software we write and not treat resources like CPU and storage as an infinite commodity.

Sustainable Demand Shifting is a pattern for enabling applications to run where and when the carbon intensity is at its lowest.

Sustainable demand shifting can be achieved in 2 different ways:

* **Spatial shifting:** Moving your workload to another physical location.
* **Tempiral shifting:** Running your workload at a different time.

The objective of sustainable demand shifting is to run your workload where/when the carbon intensity is at its
lowest in order to minimise the amount of carbon emitted per unit of work.

In this demo, we showcase two spatial shifting strategies:

* **User-led:** This strategy lets the user decide where they want to run the workload.
* **App-led:** This strategy lets the app decide where to run the workload.
  In both strategies, the workload is executed in a specific region of Azure.
  In this demo, the work can be executed in either UK South (Great Britain) or North Europe (Ireland).

The default mode is App-led, i.e. the app will decide the most efficient region to execute the work by comparing the
the carbon intensity of the two regions and selecting the one the lowest emissions. However, the user can override
this and make a concious decision as to where to which region to run the work.

![SDSPage](/src/Web/wwwroot/images/screenshotSDSPage.png)

Emissions data is provided by [Electricity Maps](https://app.electricitymaps.com/) via the Carbon Aware SDK.

## Architecture
---
The diagram below illustrates the key components of the demo.
![AppDiagram](/src/Web/wwwroot/images/systemDiagram3.png)

## Getting Started
---
### Deploy Azure Components

In the integrated terminal navigate to src\\ and run the following command:

```
New-AzSubscriptionDeployment -Location uksouth -TemplateFile Deploy\main.bicep -resourceGroupName insert_resource_group_name_here
```

Follow the instructions on the [carbon aware](https://github.com/Green-Software-Foundation/carbon-aware-sdk/tree/dev) github page to push a WebApi image to the newly created registry.

Next navigate to src\\API, deploy the functions by running the following commands:

```
func azure functionapp publish insert_name_of_functionApp_located_in_UKS_here \API –force -csharp
func azure functionapp publish insert_name_of_functionApp_located_in_NEU_here \API –force -csharp
```

Next return to src\\ and run the following command to deploy the container app and apim. You will need to insert the resource group name, the registry name and key, the publisher name and email and the doWork function keys.

```
New-AzResourceGroupDeployment -TemplateFile Deploy\deployApimCapp.bicep -ResourceGroupName insert_resource_group_name_here -acrName insert_registry_name_here -acrPass insert_registry_key_here -pubName insert_publisher_name_here -adminEmail insert_admin_email_here -functionNeupass insert_DoWork_NEUfunction__key_here -functionUkspass insert_DoWork_UKSfunction__key_here
```

### Manage User Secrets

Initialise user secrets for the project by running the following command:

```
dotnet user-secrets init --project Web\Web.csproj
```

Insert the APIM/Capp URLs as user secrets:

```
dotnet user-secrets set "ConnectionStrings:apim" "insert_apim_uri_here" --project Web\Web.csproj
dotnet user-secrets set "ConnectionStrings:capp" "insert_capp_manager_uri_here" --project Web\Web.csproj
```

Finally, run Web.csproj.

## References
---
- [Demand Shifting by the Green Software Foundation](https://learn.greensoftware.foundation/carbon-awareness/#demand-shifting)
- [FSP white paper on sustainable digital transformation](https://fsp.co/sustainable-digital-transformation/)
- [Carbon Aware SDK by the Green Software Foundation](https://github.com/Green-Software-Foundation/carbon-aware-sdk)
- [Electricity Maps](https://app.electricitymaps.com/)