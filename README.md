# Terraform

**Watch the video [here](https://youtu.be/jv9n0fxAWA0)**

## Prerequisites

- Install [Terraform](https://www.terraform.io/downloads.html)
- [Obtain a free Azure Account](https://azure.microsoft.com/en-us/free/)
- Install [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)

## Loose Agenda

Codify our free Azure Web App instance hosting a Web API image from the [Azure Web App Exercise](2021-12-05-azure-app-service.md).

## Step by Step

### Setup Playground

Create a directory for today's exercise. Navigate to the new directory in a terminal instance.

**Note - If you previously performed the Azure Web App Exercise you should delete the resource group in advance of this exercise.**

### Create our Terraform Definition

Create a file named `main.tf` in the directory. 

We'll need to specify which provider we're using. In this case we will use Terraform's Azure provider

```yaml
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.46.0"
    }
  }
}

provider "azurerm" {
  features {}
}
```

Next, we'll want to specify our resource group

```yaml
resource "azurerm_resource_group" "nonzero" {
  name     = "rg-non-zero-packages"
  location = "West US 2"
}

```

We'll want an App Service Plan
```yaml
resource "azurerm_app_service_plan" "nonzero" {
  name                = "sp-non-zero-packages"
  location            = azurerm_resource_group.nonzero.location
  resource_group_name = azurerm_resource_group.nonzero.name
  kind                = "Linux"
  reserved            = true

  sku {
    tier = "Free"
    size = "F1"
  }
}

```

Finally, we'll want to define our App Service
```yaml
resource "azurerm_app_service" "nonzero" {
  name                = "app-non-zero-packages"
  location            = azurerm_resource_group.nonzero.location
  resource_group_name = azurerm_resource_group.nonzero.name
  app_service_plan_id = azurerm_app_service_plan.nonzero.id
  
  site_config {
    linux_fx_version    = "DOCKER|ghcr.io/boredtweak/non-zero-packages:latest"
    use_32_bit_worker_process   = true
  }
}

```

### Run the Terraform Definition

Run `az login` to login to your Azure subscription.

Run `terraform init` to create a terraform lock file for this directory and pull down any dependencies.

Run `terraform fmt` to format the terraform code.

Run `terraform plan` to test run the terraform definition.

Finally, run `terraform apply` to persist the terraform definition into Azure infrastructure.

Navigate to your deployed WebAPI resource's Swagger page (e.g. - https://app-non-zero-packages.azurewebsites.net/swagger/index.html) and call an API.

### Configuration

Adjust the `resource "azurerm_app_service" "nonzero"` section of our terraform definition to include a new `app_settings` section.

```yml
resource "azurerm_app_service" "nonzero" {
  name                = "app-non-zero-packages"
  location            = azurerm_resource_group.nonzero.location
  resource_group_name = azurerm_resource_group.nonzero.name
  app_service_plan_id = azurerm_app_service_plan.nonzero.id

  site_config {
    linux_fx_version          = "DOCKER|ghcr.io/boredtweak/non-zero-packages:latest"
    use_32_bit_worker_process = true
  }
  
  app_settings = {
    "NON_ZERO_VALUE" = "day"
  }
}
```

Now run through the steps to run the terraform definition again. 

- `terraform init`
- `terraform fmt`
- `terraform plan`
  - Note that this step shows 1 item to change.
- `terraform apply`

Navigate to your deployed WebAPI resource's Swagger page again and call the `/WeatherForecast/configuration` API.

## Additional Resources

- [Terraform Azure Documentation](https://learn.hashicorp.com/collections/terraform/azure-get-started)
- [Azure App Service Documentation](https://docs.microsoft.com/en-us/azure/app-service/overview)
- [Azure Free Tier](https://azure.microsoft.com/free)
