terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

provider "azurerm" {
  features {}
client_id = var.client_id
client_secret = var.client_secret
subscription_id = var.subscription_id
tenant_id = var.tenant_id
}


#Connecting to the networking module. 

module "networking" {
  source = "./modules/networking-module" 
  resource_group_name = "networking-resource-group"
  location            = "UK South"
  vnet_address_space  = ["10.0.0.0/16"]
}

#Connecting to the cluster module. 

module "aks-cluster-module" {
  source = "./modules/aks-cluster-module"
  aks_cluster_name            = "terraform-aks-cluster"
  cluster_location            = "UK South"
  dns_prefix                  = "myaks-project"
  kubernetes_version          = "1.29.0"
  client_id                   = var.client_id
  client_secret               = var.client_secret
  resource_group_name         = module.networking.resource_group_name
  vnet_id                     = module.networking.vnet_id
  control_plane_subnet_id     = module.networking.control_plane_subnet_id
  worker_node_subnet_id       = module.networking.worker_node_subnet_id
} 


