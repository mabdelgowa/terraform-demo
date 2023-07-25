# terraform-demo overview

### Note: the (terraform.tfvars) file is customized with particular values for every user 
### Note: credentials of the AWS user are added as environment variables before starting 
### Note: This project is modularized in the branch of the module, and every module has its main.tf, variables.tf, and output.tf files


## Provision AWS infrastructure
### 1- create a custom VPC
### 2- create a custom subnet
### 3- create a custom route table and internet gateway
### 4- create a custom security group
### 5- provision EC2 instance

## Run nginx Docker container on EC2 insurance
### Run bash script as user data to:
###     1- install docker in the EC2 instance 
###     2- deploy the nginx docker container in the EC2 instance

## Modules branch
### This branch contains the same things as the master branch, but everything is separated in a separate module.
### We have two modules:
###    1- subnet: for provisioning the subnet, route table, and internet gateway
###    2- webserver: for provisioning the security group, the EC2 instance and running the bash script user data




## Documentation video in the following link
### [Video link](https://drive.google.com/file/d/1rgRWDRta8UmR7V1WB6a1ATAmBm9Vlho6/view?usp=sharing)
