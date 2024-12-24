# Project-1

## Introduction

>This Terraform project is designed to automate the creation of infrastructure and deployment of applications in AWS. By defining your infrastructure as code, this project ensures a consistent, repeatable, and automated way to manage your cloud resources.

## Prerequisites

Here is the link for official terraform page and install the terraform based on your os:

- [https://www.terraform.io/downloads.html](https://www.terraform.io/downloads.html)

## Setup

Instructions on how to set up the project:

1. Clone the repository

   ```sh
   git clone https://github.com/yourusername/your-repo.git
2. Change directory into the project folder

   ```sh
   cd your-repo
3. Initialize Terraform

    ```sh
    terraform init
    ```

## Configuration

### Variables

` vpc1_subnet `

This variable defines the configuration for VPC subnets. Each subnet object includes:

- **name:** The name of the subnet.
- **cidr:** The CIDR block for the subnet.
- **az:** The availability zone for the subnet.
- **public_ip:** A boolean indicating whether the subnet should have a public IP.

```Hcl
variable "vpc1_subnet" {
  type = list(object({
    name      = string,
    cidr      = string,
    az        = string,
    public_ip = bool
  }))
  default = [
    { "name" = "subnet-1", "cidr" = "192.168.10.1/24", "az" = "a", "public_ip" = true },
    { "name" = "subnet-2", "cidr" = "192.168.10.2/24", "az" = "b", "public_ip" = false }
  ]
}
```

`public_key_path`

This variable defines the path to the public key file used for SSH access to instances.

```Hcl
variable "public_key_path" {
  type        = string
  description = "Path to the public key file"
}
```

`instance`

This variable defines the configuration for instances. Each instance object includes:

- **name:** The name of the instance.
subnet: The subnet where the instance is located.
- **az:** The availability zone for the instance.
- **public_ip:** A boolean indicating whether the instance should have a public IP.

```Hcl
variable "instance" {
  type = list(object({
    name      = string,
    subnet    = string,
    az        = string,
    public_ip = bool
  }))
  default = [
    { "name" = "instance-1", "subnet" = "subnet-1", "az" = "a", "public_ip" = true },
    { "name" = "instance-2", "subnet" = "subnet-2", "az" = "b", "public_ip" = false }
  ]
}
```

`lb_target`

This variable defines the list of instances that are targets for the load balancer.

```Hcl
variable "lb_target" {
  type = list(object({
    instance = string
  }))
  default = [
    { "instance" = "instance-1" },
    { "instance" = "instance-2" }
  ]
}
```

## Credentials

### To set up AWS credentials

```sh
export AWS_ACCESS_KEY_ID="your-access-key-id"
export AWS_SECRET_ACCESS_KEY="your-secret-access-key"
```

## Store the db-password in AWS Secrets Manager

- Go to the AWS Management Console.
- Navigate to Secrets Manager.
- Click on Store a new secret.
- Choose Other type of secret and enter your database password.
- Click Next and follow the prompts to give your secret a name and configure other settings.
- Finally, click Store to save your secret.

## IAM Policies Used

### IAM Role for EC2

```Hcl
resource "aws_iam_role" "ec2_role" {
  name = "ec2_role"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ec2_policy" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
}
```

### IAM Role for RDS

```Hcl
resource "aws_iam_role" "rds_role" {
  name = "rds_role"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "rds.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "rds_policy" {
  role       = aws_iam_role.rds_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}
```

## Usage

Instructions on how to use your Terraform code:

1. Plan the deployment

    ```sh
    terraform plan
2. Apply the deployment

    ```sh
    terraform apply -var-file="terraform.tfvars"
    ```

## Resources

Resources this Terraform code will create or manage, such as:

- VPC

- Subnets

- EC2 Instances

- RDS Instances

## Assumptions Made

- The public key used for SSH access is securely stored and accessible.

- AWS credentials are properly configured and have sufficient permissions to create the necessary resources.

- The application code is packaged and ready for deployment.

## Deliverables

- Terraform code to create infrastructure.

- README.mdwith detailed setup and deployment instructions.

- IAM roles and policies for EC2 and RDS instances.

- Security groups configured as per the requirements.

## Cleanup

To destroy the infrastructure when it is no longer needed:

```sh
terraform destroy
```
