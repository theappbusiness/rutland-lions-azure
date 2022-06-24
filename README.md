# Rutland Lions Azure Infrastructure

This repo contains the Terraform codebase describing the Rutland Lions Azure infrastructure. This repository acts as the soruce of truth for Azure infrastructure, and any changes to that infrastructure should follow the a GitOps process of checking out a new branch, making any necessary changes, then raising a pull request for approval prior to merging into the main branch. Continuous integration and continuous delivery pipelines have been configured to run automated code validation and security checks on pushes to any branch, and automated deployments to the devleopment environment on successful merge to main. This process is described in more detail below.

## Repo Structure

```
.
+-- .github
|	+-- workflows
|		+-- terraform-cd.yml
|		+-- terraform-ci.yml
+-- infrastructure
|	+-- .tflint.hcl
|	+-- modules
|	|	+-- kc-common-vnet
|	|	+-- kc-vnet-to-vnet-peering
|	|	+-- kc-two-tier-vm-app
| +-- resource-groups.tf
|	+-- locals.tf
|	+-- provider.tf
|	+-- variables.tf
| +-- workload.tf
+-- .gitignore
+-- .pre-commit-config.yaml
+-- README.md
```

- The `.github/workflows` directory contains the GitHub Actions pipelines for Terraform CI and CD. These are explained in more details later. Further pipelines could be added here, for example `app-build` and `app-release` pipelines to build and deploy an app to the deployed infrastructure if the same repo is to be used.
- The `infrastructure` directory contains the main deployment files and dependent submodules to be deployed. The main `deploy.tf` file is designed to call the modules for deployment. A `locals.tf` may contain maps with per-environment configuration to differentiate deployments per environment, explained in more detail later. A `provider.tf` describes the provider versions to use, as well as the remote backend configuration for storing Terraform remote state.
- The `infrastructure/modules` directory contains environment-agnostic one or more modules to be deployed. These can be thought of as a service or services comprising a single workload or landing-zone deployment. Modules themselves may have submodules if required.
- The `pre-commit-config.yaml` file describes Pre-Commit hooks to be used in case the engineer working with the repo is using Pre-Commit locally. Instructions on how to install and use Pre-Commit are explained later.
- The `.tflint.hcl` file describes the TFLint plugins and rules to run. TFLint is a linting tool used as part of the CI pipeline, explained in more detail later.

When working with a copy of this repository it is expected that the engineer will remove the example modules from the `infrastructure/modules` directory and create their own Terraform module(s) describing the workload they are looking to deploy.

The `provider.tf` file in the main `infrastructure` directory should be updated with the subscription and storage account details for storing remote state. The `locals.tf` and `deploy.tf` files in the main `infrastructure` directory would then be updated to call the module(s) describing the workload.

This way, the engineer may only concern themselves with writing the Terraform required for their workload, with the pipelines and repository structure already in place to enable automated deployments.

## Tooling Setup

This repo makes use of certain tools which should be installed locally to aid development. All tools are available through the Brew package manager which can be installed on MacOS and Linux. Windows users will need to install Windows Subsystem for Linux (WSL) as described below.

### Brew (Windows)

The below command will enable WSL and install the Ubuntu distribution locally:

````
wsl --install
````

### Bew (MacOS, Linux, WSL)

Brew can be installed with the below command, as per https://brew.sh:

````
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
````

### TFEnv and Terraform

TFEnv is recommended when working with local Terraform installations as it allows multiple versions to be installed simultaneously. The below installs `tfenv` and Terraform `1.1.6`:

````
brew install tfenv
tfenv install 1.1.6
````

### TFLint

TFLint must be initialized in the `infrastructure` directory before use. It uses the `.tflint.hcl` configuration file to determine which plugins and rules to use:

````
brew install tflint
cd infrastructure
tflint --init
````

### Checkov

Checkov scans Terraform files for Azure-specific resource definitions to detect security misconfigurations:

````
brew install checkov
````

Sometimes insecure configuration may be permissible, for example in development or testing. Resources in Terraform can be marked with a comment telling Checkov to ignore a specific check. The comment format can be seen below starting with Checkov, followed by the check ID, then the reason that the check is skipped:

````
resource "azurerm_storage_account" "my_storage_account" {
  #checkov:skip=CKV_AZURE_109: Skip reason
  ...
}
````

### Pre-Commit

Pre-Commit can be thought of as a local CI pipeline. It runs checks against your commits and will abandon the commit if any of the checks fail. This speeds up development and ensure high code quality before commits or PRs are made:

````
brew install pre-commit
````

Pre-Commit is triggered when `git commit` is run, or optionally can be run manually with the `pre-commit` command. The `.pre-commit-config.yaml` file describes the Pre-Commit hooks to use, and includes hooks for Terraforms `fmt` and `validate` commands, TFLint and Checkov, as well as generic checks for trailing whitespace:

````
fix end of files.........................................................Passed
trim trailing whitespace.................................................Passed
Terraform docs...........................................................Passed
Terraform fmt............................................................Passed
Terraform validate.......................................................Passed
Terraform validate with tflint...........................................Passed
Checkov..................................................................Passed
````

## Getting Started

This repo can be cloned by selecting the *Use this template* button then creating a new repository in the organization of your choice. Once cloned, a few manual steps are required.

### Repository Configuration

This repo uses GitHub Actions pipelines which in turn read secret values from GitHub Actions secrets. The below secrets  should be created by navigating to *Settings > Secrets > Actions* then selecting *New repository secret*:

| Secret Name         | Description                                                  | Example Value                                                |
| ------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| ARM_CLIENT_ID       | Terraform service principal ID used by the Terraform `azurerm` provider | `c2178f69-6e4d-4961-a170-3f366b1d43b4`                       |
| ARM_CLIENT_SECRET   | Terraform service principal secret used by the Terraform `azurerm` provider | `i~.8Q~NFsvVQlHJpVGwVjEmFsWcUnZuvYusUVczS`                   |
| ARM_SUBSCRIPTION_ID | Azure subscription ID used by the Terraform `azurerm` provider | `b0a4abbf-4de3-4349-8ea0-aaea12213f72`                       |
| ARM_TENANT_ID       | Azure tenant ID used by the Terraform `azurerm` provider     | `2e45679d-f4e1-4ac6-891a-2f835833c0f5`                       |
| AZURE_CREDENTIALS   | Azure credentials used by the Azure Login GitHub Action      | `{"clientId": "c2178f69-6e4d-4961-a170-3f366b1d43b4", "clientSecret": "i~.8Q~NFsvVQlHJpVGwVjEmFsWcUnZuvYusUVczS",  "subscriptionId": "b0a4abbf-4de3-4349-8ea0-aaea12213f72",  "tenantId": "2e45679d-f4e1-4ac6-891a-2f835833c0f5",  "resourceManagerEndpointUrl": "https://management.azure.com/"}` |

### Provider Configuration

Terraform is configured to use a remote backend for state storage, in this case an Azure Storage Account. To avoid a circular dependency, a Storage Account should be manually created with a container for storing Terraform state. The `backend` object in the `provider.tf` file must then be updated with the details of the Storage Account:

```
terraform {
  backend "azurerm" {
    container_name       = "<storageAccountContainerName>"
    key                  = "terraform.tfstate"
    resource_group_name  = "<storageAccountResourceGroupName>"
    subscription_id      = "<storageAccountSubscriptionId>"
    storage_account_name = "<sotrageAccountName>"
  }
  ...
}
```

Optionally, the versions of Terraform, and the `azurerm` provider may be specified as required. By default, Terraform is set to version `1.1.6` specifically, and `azurerm` to any `3.x.x` version:

```
terraform {
  ...
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }

  required_version = "1.1.6"
}
```

### Azure Configuration

With the above steps completed, use the Azure CLI to login to Azure. If this step is performed through the Azure Cloud Shell you will need to make sure to clone the repository to your Cloud Shell environment first:

````
az login --tenant <tenantId>
az account set --subscription <subscriptionId>
````

Navigate to the `infrastructure` directory and initialize Terraform:

````
cd infrastructure
terraform init
````

The GitHub Actions pipelines expect the use of Terraform Workspaces to differentiate between deployment environments. The names of these environments are specified in the `terraform-cd` pipeline and can be changed if desired. Otherwise, create the following workspaces:

````
terraform workspace new dev
terraform workspace new test
terraform workspace new prod
````

Finally, select the `dev` workspace to ensure any local plans and deployments will target the development environment:

````
terraform workspace select dev
````

## Pipelines
GitHub Actions pipelines are stored in the `.github\workflows` directory. An example continuous integration (CI) and continuous delivery (CD) pipeline have been provided. The pipelines have conditions for automated runs, as well as a `workflow_dispatch` configuration to allow manually runs targetting specific branches and environments.

````yaml
  workflow_dispatch:
    inputs:
      environment:
        type: choice
        description: 'The environment to deploy to'
        required: true
        default: dev
        options:
        - dev
        - test
        - prod
````

### Terraform CI
The Terraform CI pipeline is responsible for validating code quality, stylistic error (linting), and security misconfigurations. It does this using native Terraform commands (fmt, validate), TFLint, and Checkov. The complete list of CI steps are as follows:

| Step               | Description                                                  |
| ------------------ | ------------------------------------------------------------ |
| Checkout           | Checks-out the GitHub repository to the agent                |
| Azure Login        | Authenticates to Azure using the GitHub Actions secret AZURE_CREDENTIALS |
| Terraform Setup    | Downloads and installs the specified version of Terraform to the agent |
| Terraform Init     | Initializes Terraform in the specified directory             |
| Terraform Format   | Checks the format and style of Terraform files in the specified directory |
| Terraform Validate | Validates the syntax the Terraform files in the specified directory |
| TFLint Setup       | Downloads and installs TFLint to the agent                   |
| TFLint Init        | Initializes TFLint in the specified directory                |
| TFLint Validate    | Performs linting checks on the Terraform files in the specified directory |
| Checkov Validate   | Performs security checks on the Terraform files in the specified directory |

In addition to the option of running manually, the Terraform CI pipeline is triggered off pushes to **any** branch where the commit file(s) exist within the `infrastructure` directory. The ensures code quality is consistent and acceptable before pull requests to the main branch are submitted:

```yaml
on:
  push:
    branches:
      - '**'
    paths:
      - infrastructure/**
```

Several environment variables are used by Terraform to initialise the remote backend (Azure Storage Account). These are passed into the agent with the `env` keyword. The values are stored in GitHub Actions secrets:

```yaml
env:
  ARM_CLIENT_ID: ${{ secrets.ARM_CLIENT_ID }}
  ARM_CLIENT_SECRET: ${{ secrets.ARM_CLIENT_SECRET }}
  ARM_SUBSCRIPTION_ID: ${{ secrets.ARM_SUBSCRIPTION_ID }}
  ARM_TENANT_ID: ${{ secrets.ARM_TENANT_ID }}
```

### Terraform CD
The Terraform CD pipeline is responisble for deploying the Terraform infrastructure code to Azure. The pipeline consists of two jobs; Terraform Plan, and Terraform Apply. The apply stage is depends on the plan stage passing, as it is possible misconfiguration to be detected in the plan stage. If the plan stage is successful, the plan is saved as an artifact and passed to the apply stage for deployment. The complete list of the CD steps are as follows:

**Plan**
| Step                | Description                                                  |
| ------------------- | ------------------------------------------------------------ |
| Checkout            | Checks-out the GitHub repository to the agent                |
| Azure Login         | Authenticates to Azure using the GitHub Actions secret AZURE_CREDENTIALS |
| Terraform Setup     | Downloads and installs the specified version of Terraform to the agent |
| Terraform Init      | Initializes Terraform in the specified directory             |
| Terraform Workspace | Selects the Terraform workspace to use for environment deployment |
| Terraform Plan      | Checks the current state vs desired state and outputs a deployment plan |
| Upload Artifact     | Uploads the Terraform Plan output as an artifact             |

**Apply**
| Step                | Description                                                  |
| ------------------- | ------------------------------------------------------------ |
| Checkout            | Checks-out the GitHub repository to the agent                |
| Download Artifact   | Downloads the Terraform Plan output artifact                 |
| Azure Login         | Authenticates to Azure using the GitHub Actions secret AZURE_CREDENTIALS |
| Terraform Setup     | Downloads and installs the specified version of Terraform to the agent |
| Terraform Init      | Initializes Terraform in the specified directory             |
| Terraform Workspace | Selects the Terraform workspace to use for environment deployment |
| Terraform Apply     | Deploys infrastructure based on the Terraform Plan output artifact |

In addition to the option of running manually, the Terraform CD pipeline is triggered off pushes to the **main** branch where the commit file(s) exist within the `infrastructure` directory. The ensures deployments are triggered only on successful merges to the main branch, typically after a pull request has been approved:

```yaml
on:
  push:
    branches:
      - main
    paths:
      - infrastructure/**
```

Several environment variables are used by Terraform to initialise the remote backend (Azure Storage Account). These are passed into the agent with the `env` keyword. The values are stored in GitHub Actions secrets:

```yaml
env:
  ARM_CLIENT_ID: ${{ secrets.ARM_CLIENT_ID }}
  ARM_CLIENT_SECRET: ${{ secrets.ARM_CLIENT_SECRET }}
  ARM_SUBSCRIPTION_ID: ${{ secrets.ARM_SUBSCRIPTION_ID }}
  ARM_TENANT_ID: ${{ secrets.ARM_TENANT_ID }}
```

## Infrastructure
All infrastructure code is located in the `infrastructure` directory. The provider and backend configuration have already been defined, but the backend configuration will need to be updated to reflect the desired Storage Account for storing Terraform state. Amend the following values in `provider.tf`:

````
terraform {
  backend "azurerm" {
    container_name       = "<storageAccountContainerName>"
    key                  = "terraform.tfstate"
    resource_group_name  = "<storageAccountResourceGroupName>"
    subscription_id      = "<storageAccountSubscriptionId>"
    storage_account_name = "<sotrageAccountName>"
  }
  ...
}
````

### Environment Deployments
Deployments to individual environments (`dev`, `test`, `prod`) are supported through the use of Terraform Workspaces. By default, the CD pipeline will deploy dev resources, but can be run manually with the environment choice set to `test` or `prod`. The workspace name is made available in the Terraform configuration through the use of the `terraform.workspace` variable.

Terraform conditions or strings can use the value of `terraform.workspace` to alter the deployment type or name of resources dependent on the chosen environment. Modules should be designed as environment-agnostic, and variables configured for any attribute that might be configured different per environment, for example resource SKUs, number of instances, storage quotas. The main `locals.tf` can then utilize a map of environment-specific configuration options to be passed into the module which will be loaded depending on the Terraform workspace context.

As an example, consider a module that deploys Azure Kubernetes Service with the below configuration that would be defined in a file located at `infrastructure/modules/example-kubernetes/kubernetes-service.tf`:

````
resource "azurerm_kubernetes_cluster" "example_kubernetes" {
  name                = "aks-ex-aks-${var.environment}"
  resource_group_name = azurerm_resource_group.example_kubernetes.name
  location            = azurerm_resource_group.example_kubernetes.location
  dns_prefix          = "exk8s${var.environment}"
  node_resource_group = "rg-ex-aks-nodes-${var.environment}"

  default_node_pool {
    name       = "default"
    vm_size    = var.kubernetes_node_vm_sku
    node_count = var.kubernetes_node_count
  }

  identity {
    type = "SystemAssigned"
  }
}
````

The AKS VM node size and node count may be different per environment, and so these values are taken from input variables to the module (`kubernetes_node_vm_sku`, `kubernetes_node_count`). Similarly the name of the AKS cluster may include the environment name which again can be passed into the module with a variable (`environment`). These variables should be defined in a `variables.tf` file inside the module with default values provided:

```
variable "environment" {
  default     = "dev"
  description = "The environment name in which to deploy resources"
  type        = string
}

variable "kubernetes_node_vm_sku" {
  default     = "Standard_D2_v2"
  description = "The VM SKU for each node in the Kubernetes cluster"
  type        = string
}

variable "kubernetes_node_count" {
  default     = 1
  description = "The number of nodes in the Kubernetes cluster"
  type        = number
}

...

```

In the main deployment directory, the `locals.tf` file can be used to define a map of per-environment deployment options to be passed into the module. As an example, the below defines an AKS cluster of one node with Standard D2 VMs for `dev`, a three-node cluster with Standard D2 VMs for `test`, and a three-node cluster with Standard D3 VMs for `prod` as defined in the file located at `infrastructure/locals.tf`:

````
locals {
  kubernetes_module_configuration = {
    dev = {
      kubernetes_node_count  = 1
      kubernetes_node_vm_sku = "Standard_D2_v2"
    }
    test = {
      kubernetes_node_count  = 3
      kubernetes_node_vm_sku = "Standard_D2_v2"
    }
    prod = {
      kubernetes_node_count  = 3
      kubernetes_node_vm_sku = "Standard_D3_v2"
    }
  }
}
````

In the main module directory, the `deploy.tf` file is used to call the module. The map of environment-specific configuration can be referenced from the `locals.tf` as follows:

````
module "example_kubernetes" {
  source = "./modules/example-kubernetes"

  environment            = terraform.workspace
  kubernetes_node_count  = local.kubernetes_module_configuration[terraform.workspace].kubernetes_node_count
  kubernetes_node_vm_sku = local.kubernetes_module_configuration[terraform.workspace].kubernetes_node_vm_sku
}
````

The above makes use of the `terraform.workspace` variable to determine which environment configuration to choose. The local `kubernetes_module_configuration` object is then referenced, and sub-object (environment: (`dev`, `test`, or `prod`) selected based on the current environment.

Ternary operators may instead be used in place of a `locals.tf` map if the per-environment configuration should be one of two options, for example if `test` and `prod` should have identical configuration, but `dev` toned-down, then the options may be directly defined in the `deploy.tf` module call. The below defines an AKS cluster with one node with Standard D2 VMs for `dev`, and a three-node cluster with Standard D3 VMs for `test` and `prod`:

````
module "example_kubernetes" {
  source = "./modules/example-kubernetes"

  environment            = terraform.workspace
  kubernetes_node_count  = terraform.workspace == "dev" ? 1 : 3
  kubernetes_node_vm_sku = terraform.workspace == "dev" ? "Standard_D2_v2" : "Standard_D3_v2"
}
````
