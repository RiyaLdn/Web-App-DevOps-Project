# Web-App-DevOps-Project

Welcome to the Web App DevOps Project repo! This application allows you to efficiently manage and track orders for a potential business. It provides an intuitive user interface for viewing existing orders and adding new ones.

## Table of Contents

- [Features](#features)
- [Reverted Feature](#reverted-feature)
- [Re-implimenting the feature](#re-implimenting-the-feature)
- [Getting Started](#getting-started)
- [Technology Stack](#technology-stack)
- [Containerization with Docker](#containerization-with-docker)
    - [Containerization Process](#containerization-process)
    - [Docker Commands](#docker-commands)
    - [Image Information](#image-information)
 - [Infrastructure as Code with Terraform](#infrastructure-as-code-with-Terraform)
    - [Introduction](#introduction)
    - [Terraform Modules](#terraform-modules)
                - [Networking Module](#networking-module)
                - [AKS Cluster Module](#aks-cluster-module)
    - [Main Project Configuration](#main-project-configuration)
- [Kubernetes Deployment to AKS](#kubernetes-deployment-to-AKS)
     - [Deployment and Service](#deployment-and-service)
     - [Deployment Strategy](#deployment-strategy)
     - [Testing and Validation](#testing-and-validation)
- [Contributors](#contributors)
- [License](#license)

## Features

- **Order List:** View a comprehensive list of orders including details like date UUID, user ID, card number, store code, product code, product quantity, order date, and shipping date.
  
![Screenshot 2023-08-31 at 15 48 48](https://github.com/maya-a-iuga/Web-App-DevOps-Project/assets/104773240/3a3bae88-9224-4755-bf62-567beb7bf692)

- **Pagination:** Easily navigate through multiple pages of orders using the built-in pagination feature.
  
![Screenshot 2023-08-31 at 15 49 08](https://github.com/maya-a-iuga/Web-App-DevOps-Project/assets/104773240/d92a045d-b568-4695-b2b9-986874b4ed5a)

- **Add New Order:** Fill out a user-friendly form to add new orders to the system with the necessary information.
  
![Screenshot 2023-08-31 at 15 49 26](https://github.com/maya-a-iuga/Web-App-DevOps-Project/assets/104773240/83236d79-6212-4fc3-afa3-3cee88354b1a)

- **Data Validation:** Ensure data accuracy and completeness with required fields, date restrictions, and card number validation.

## Reverted Feature

- **Delivery Date:** The Delivery Date feature was designed to easily track the delivery date for orders being made. While the feature has been reverted, this section provides insights into its purpose and functionality. 

### Re-Implementing the Feature

To re-implement the delivery date feature, follow the steps below: 

1. **Step 1:** Modify the order class in the `app.py` file. Add a `delivery-date` column to the class attributes.
2. **Step 2:** In the route to add orders section of code, `app.route`, update the form to include the `deliver_date` field.
3. **Step 3:** Also in the route to add orders section of code, `app.route`, add `delivery_date` to the bottom of the `new_order` variables list.
4. **Step 4:** In the `order.html` template, update the table header and rows to include the `delivery_date` column. Modify the `<th>` elements and the `{% for order in orders %}` loop accordingly.
5. **Step 5:** Again in the `order.html` template, modify the `<form>` element to include an input field for the `delivery_date` column.

These are all the steps necessary to facilitate all the functionality of the web application to support a new column `delivery_date`.

## Getting Started

### Prerequisites

For the application to successfully run, you need to install the following packages:

- flask (version 2.2.2)
- pyodbc (version 4.0.39)
- SQLAlchemy (version 2.0.21)
- werkzeug (version 2.2.3)

### Usage

To run the application, you simply need to run the `app.py` script in this repository. Once the application starts you should be able to access it locally at `http://127.0.0.1:5000`. Here you will be met with the following two pages:

1. **Order List Page:** Navigate to the "Order List" page to view all existing orders. Use the pagination controls to navigate between pages.

2. **Add New Order Page:** Click on the "Add New Order" tab to access the order form. Complete all required fields and ensure that your entries meet the specified criteria.

## Technology Stack

- **Backend:** Flask is used to build the backend of the application, handling routing, data processing, and interactions with the database.

- **Frontend:** The user interface is designed using HTML, CSS, and JavaScript to ensure a smooth and intuitive user experience.

- **Database:** The application employs an Azure SQL Database as its database system to store order-related data.

- **Containerization:** Docker is utilised to create a containerized environment for the app, to ensure seamless deployment and scalability.

- **Infrastructure as Code (Iac):** Terraform is leveraged to create configuration files to assist with deployment, scalability, and orchestration of the containerized application seamlessly on Azure Kubernetes Service (AKS).

- **Orchestration:** The open-source container application platform, Kubernetes, is used for automating the deployment, scaling, and management of the containerized application. 

## Containerization with Docker

### Containerization Process

A Dockerfile is used to containerize this application, encapsulating all necessary dependencies and configuration settings. In particular: 

- It defines the steps required to build the Docker image for the application.
- Sets up the working directory.
- Copies packages.
- Installs dependencies.
- Copies the application's code to the container.
- Exposes the port where the app will run.
- Defines how to start the application.

The following steps were taken to containerize this application specifically: 

```Dockerfile

# Step 1 - Use an official Python runtime as a parent image. You can use `python:3.8-slim`.
FROM python:3.8-slim

# Step 2 - Set the working directory in the container
WORKDIR /app

# Step 3 - Copy the application files in the container
COPY . /app

# Step 4 - Install system dependencies and ODBC driver
RUN apt-get update && apt-get install -y \
    unixodbc unixodbc-dev odbcinst odbcinst1debian2 libpq-dev gcc && \
    apt-get install -y gnupg && \
    apt-get install -y wget && \
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
    wget -qO- https://packages.microsoft.com/config/debian/10/prod.list > /etc/apt/sources.list.d/mssql-release.list && \
    apt-get update && \
    ACCEPT_EULA=Y apt-get install -y msodbcsql18 && \
    apt-get purge -y --auto-remove wget && \  
    apt-get clean

# Step 5 - Install pip and setuptools
RUN pip install --upgrade pip setuptools

# Step 6 - Install Python packages specified in requirements.txt
RUN pip install --trusted-host pypi.python.org -r requirements.txt

# Step 7 - Expose port 
EXPOSE 5000

# Step 8 - Define Startup Command
CMD ["python", "app.py"]

```
### Docker Commands

1. **Building the Docker Image:** ``` docker build -t your-image-name:your-tag . ``` This command builds a Docker image from the current directory and tags it with the specified name and tag. Make sure to replace `your-image-name:your-tag` with the specified name and tag. 
2. **Running Containers:** ``` docker run -p port:port your-image-name:your-tag ``` This command runs a container based on the specified image. It also maps port 5000 on the host to port 5000 in the container. 
3. **Tagging Image:** ``` docker tag your-image-name:your-tag your-dockerhub-username/your-repo:your-tag ``` This command tags the image. Replace `your-dockerhub-username` and `your-repo:your-tag` with the actual information.
4. **Pushing Image to Docker Hub:** ``` docker push your-dockerhub-username/your-repo:your-tag ``` This command pushes the image to Docker Hub. 

### Image Information

1. **Docker Image Details:**
     - `your-image-name` = `python`
     - `your-tag` = `3.8-slim`
     - `port` = `5000`

2. **Instructions for Use:**

     - To run the Dockerized application, run this command: `docker run -p port:port your-image-name:your-tag`.
     - This will start the application within the Docker container. Access it at `http://127.0.0.1:5000`.

## Infrastructure as Code with Terraform

### Introduction

Within this section, we will cover the process of defining networking services and AKS Cluster services using Terraform. Specifically this section will explain how each resource is created, its purpose, and its dependencies. 

### Terraform Modules

#### Networking Module

1. **Resources** 

The following networking resources are provisioned within this module:

- Azure Resource Group: allows for the organisation and management of related Azure resources, such as VMs, storage accounts, virtual networking, etc.
- Virtual Network (VNet): allows to securely connect Azure resources and to on-premises networks.
- Control Plane Subnet: a subnet within the Virtual Network that hosts the control plane components of Azure Kubernetes Service (AKS).
- Worker Node Subnet: a subnet within the Virtual Network dedicated to hosting the worker nodes of an AKS cluster. 
- Network Security Group (NSG): a security rule set that controls inbound and outbound traffic to network interfaces (NIC), VMs, and subnets.

To reference the configuration in the relevant file, check out [main.tf](aks-terraform/modules/networking-module/main.tf).  

2. **Input Variables**

- `resource_group_name`: This variable allows you to specify the logical container in which all networking resources, such as VNets and subnets, will be organised.
- `location`:  This variable defines the geographic location where the Azure Resource Group and associated resources, including the Virtual Network, will be created.
- `vnet_address_space`: This variable allows you to define the IP address range for the VNet, determining the private IP address space that can be used for subnets and associated resources within the VNet.

To reference the configuration in the relevant file, check out [variables.tf](aks-terraform/modules/networking-module/variables.tf). 

3. **Output Variables**

- `vnet_id`: allows reference to the VNet, allowing other modules/components to associate with this specific network. 
- `control_plane_subnet`: allows reference to the control plane subnet for configuring AKS-specific settings or associating resources.
- `worker_node_subnet_id`: allows reference to where worker nodes are deployed, for configuration with other components.
- `aks_nsg_id`: allows reference to the NSG associated with the AKS cluster, allowing for configuration with other resources. 

All of these output variables are essential for creating easy reference, integration, and configuration with other modules and components in the project. 

To reference the configuration in the relevant file, check out [outputs.tf](aks-terraform/modules/networking-module/outputs.tf). 


#### AKS Cluster Module

1. **Resources**

The following AKS CLuster resources are provisioned within this module:

- Azure Kubernetes Cluster: serves as the orchestration platform for the containerised application. It provides a scalable environment for running containers.
- Default Node Pool: This default node pool hosts the workload of the application and can be scaled based on demand. 
- Service Principle: The service principle allows the AKS Cluster to interact with other Azure resources securely.

To reference this configuration in the relevant file, check out [main.tf](aks-terraform/modules/aks-cluster-module/main.tf).

3. **Input Variables**

- `aks_cluster_name`: this variable represents the name assigned to the AKS cluster.
- `cluster_location`: specifies the Azure region where the AKS cluster will be deployed. 
- `dns_prefix`: defines the DNS prefix for the AKS cluster; this allows for the application to be accessed over the internet.
- `kubernetes_version`: specifies the version of Kubernetes that the AKS cluster will use.
- `client_id`: aa ID that is associated with the service principle, which is used for secure  authentication and access to the AKS cluster. 
- `client_secret`: a secure credential that is associated with the service principle, which is used for secure authentication and access to the AKS cluster. 

    **Input Variables from Networking Module**

    These variables are integrated from the networking module into the AKS cluster module. This is necessary as    the networking module plays an important role in establishing the networking resources for the AKS cluster.
  
    - `resource_group_name`
    - `vnet_id`
    - `control_plane_subnet`
    - `worker_node_subnet_id`

To reference this configuration in the relevant file, check out [variables.tf](aks-terraform/modules/aks-cluster-module/variables.tf).

5. **Output Variables**

- `aks_cluster_name`: this output variable is useful for obtaining the AKS cluster name after it has been successfully provisioned
- `aks_cluster_id`: a unique identifier associated with the provisoned cluster. 
- `aks_kubeconfig`: captures the Kubernetes configuration file for the AKS cluster. This file is essential for using tools like `kubectl` to interact with the AKS cluster.

To reference this configuration in the relevant file, check out [outputs.tf](aks-terraform/modules/aks-cluster-module/outputs.tf).

### Main Project Configuration

#### Terraform Provider Setup

Within the main configuration file, we have used the Azure provider for Terraform. Below is an example of the provider configuration we have used in this project: 

```
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
```

#### Connecting to the Networking Module 

Within the main configuration file for the project, it is necessary to connect to the networking module by referencing it. This integration will ensure that the networking resources previously defined in their respective module are included, and therefore accessible in the main project. The input variables are as follows:

```
module "networking" {
  source = "./modules/networking-module" 
  resource_group_name = "networking-resource-group"
  location            = "UK South"
  vnet_address_space  = ["10.0.0.0/16"]
}
```

#### Connecting to the AKS Cluster

In the main configuration file, it is also necessary to reference the AKS cluster module. This connects the AKS cluster specifications to the main project, as well as allowing for the cluster to be provisioned with the previously defined networking infrastructure. The input variables are as follows:

```
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

```

To view the main project configuration file, check out [main.tf](aks-terraform/main.tf)

## Kubernetes Deployment to AKS 

### Deployment and Service Manifests

#### Deployment

The Deployment manifest for this application defines the desired state for the deployment of the containerized web application. The key configurations are as follows: 

- **Pod Replicas:** For this particular application we chose to have 2 pod replicas, to ensure scalability and high availability of the application.
- **Selectors and Labels:** For this particular application, we have used selectors and labels to uniquely identify the application. In this case, we have used `app:flask-app` as a label establishing a clear connection between the pods and the application being managed. 
- **Container Configuration:** The manifest is configured to point to the specific Docker Hub container housing our application. The Docker image (`riyaldn/my_image.1`) and its version are crucial parameters to ensure the correct image is used.
- **Port Configuration:** For this application, we have exposed port 5000 to enable communication within the AKS cluster, serving as the gateway for accessing the application's user interface. 

#### Service 

The Service manifest is necessary for facilitating internal communication with the AKS cluster. The key configurations are as follows: 

- **Service Type:** For this particular application, we have used a ClusterIP service type, designating it as it is an internal service within the AKS cluster. 
- **Selector Matching:** The service selector matches the labels (app: flask-app) of the pods defined in the Deployment manifest. This alignment guarantees that the traffic is efficiently directed to the appropriate pods, maintaining seamless internal communication within the AKS cluster.
- **Port Configuration:** The service uses TCP protocol on port 80 for internal communication within the cluster, with the target port set to 5000, aligning with the port exposed by our container.

To check out the deployment and service manifests file, check out [application-mainfest.yaml](application-manifest.yaml)

### Deployment Strategy 

For this particular application, we have decided to implement the Rolling Updates strategy, based on a variety of reasons. Utilising the Rolling Updates strategy allows us to update our application with minimal downtime. During updates, one pod deploys while another becomes temporarily unavailable, maintaining continuous application availability.

This Rolling Updates strategy also supports scalability by allowing the deployment of multiple replicas concurrently, ensuring our application can handle increased load. 

### Testing and Validation

Once the Kubernetes manifests are deployed to AKS, it is necessary to conduct thorough testing to validate functionality and reliability within the AKS cluster. The following checks are conducted:

- **Pod Validation:** To check all the pods were running as expected, we used the command `kubectl get pods`. 
- **Service Validation:** We confirmed that services were correctly exposed within the cluster, allowing internal communication.
- **Port Forwarding:** To initiate port forwarding, we used the command, `kubectl port-forward <pod-name> 5000:5000`, to access and interact with the application locally at http://127.0.0.1:5000.

Through conducting these tests, we can ensure the functionality and reliability of the application within the AKS cluster. 

### Application Distribution 

#### Internal Users 

As this application is intended for internal use within an organisation, we can distribute the application to internal users without relying on the port forwarding method. We can do this by leveraging:

- **LoadBalancer Service Type:**

LoadBalancers would be an ideal method to distribute the application to internal users as the service will be exposed externally within the cluster. Meaning the service remains isolated within the organisation's network, preventing unauthorised access.

1. Firstly, we would update the Service manifest and change the `type` field to `LoadBalancer`.
2. Then we would apply the changes, `kubectl apply -f service.yaml`, and observe the external IP using `kubectl get services`.
3. Finally, this IP address will be used as the entry point to accessing the service. 

However, it must be noted that several other methods could also be used to distribute the service to other internal users. 

#### External Users 

Although this application is intended for internal use currently, if the need arises to share the application externally, we may leverage a different service type to distribute the application externally. We could do this by using: 

- **Ingress Controllers:**

Ingress controllers with a Service type of LoadBalancers are designed to handle HTTP/S traffic and provide a way to route external requests to different services based on URL paths. Therefore, this method would be ideal for opening the application up to external users.

1. It is important to note, that to use this method, an ingress controller must be installed: 
    a. To enable Ingress in Minikube, use the following command: `minikube addons enable ingress`. 
    b. Verify the Ingress controller is working by checking the status of the pods: `kubectl get pods -n ingress-nginx`. 
2. Next, we would start with a LoadBalancer service type, similar to the example given for [Internal Users](#internal-users).
3. Then we would create an Ingress resource: `kind: Ingress`, and would follow the standard steps to define routing rules and other configurations.
4. Apply the changes `kubectl apply -f ingress.yaml`.
5. Finally, the service can be accessed by the IP address defined in the `host` field of the file.

**Security Considerations:** 

To maintain secure external access to the application, it is possible to implement SSL termination in this case. 


## Contributors 

- [Maya Iuga]([https://github.com/yourusername](https://github.com/maya-a-iuga))

## License

This project is licensed under the MIT License. For more details, refer to the [LICENSE](LICENSE) file.
