# Deploy public EC2 Instance in AWS Cloud

## Infrastructure overview
* VPC is created with 10.254.0.0/16 CIDR
* An Internet gateway is associated to the VPC
* Route table is created with routing traffic to the internet gateway
* Subnet is created to add an EC2 instance
* Security group is added allowing only SSH (port 22) traffic
* Ubuntu 20.04 EC2 is created

## How to setup?
* Install [Terraform CLI](https://www.terraform.io/downloads)
* Create an IAM user and store credentials in your local machine
* Edit [provider.tf](provider.tf) file with your credentials file location and profile
* Run `terraform plan` to see the infrastructure plan
* Run `terraform apply` to apply changes to the cloud
