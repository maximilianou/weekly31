# weekly31

## Terraform - AWS 

**Create Infrastrcture in Any Cloud, AWS ( Linode, Azure, GCP, Digital Ocean, IBM )**

*Write Text Config File*

---
- TOC
---
1. **Terraform Concepts**
1. **Terraform Install local**
1. **Terraform Provider List**
1. **Terraform Provider connect with AWS**
1. **Terraform Provider Install AWS**
1. **Terraform AWS**
1. **Terraform AWS - Create VPC - private net/subnet**
1. **Terraform AWS - Data Sources**
1. **Terraform AWS - Change Resources**
1. **Terraform AWS - non-interactive, scriptable**
1. **Terraform AWS - State**
1. **Terraform AWS - Output**
1. **Terraform AWS - Input variables**
1. **Terraform AWS - Environment Config File, dev, staging, prod.**
1. **Terraform AWS - Variable Types**
1. **Terraform AWS - Environment Variables**
1. **Terraform AWS - Base Project**
1. **Terraform AWS - VPC & Subnet**
1. **Terraform AWS - Create Route Table & Internet Gateway**
1. **Terraform AWS - Route Table Association**
1. **Terraform AWS - Security Group**
1. **Terraform AWS - Obtain Imange Id Dinamically from AWS**
1. **Terraform AWS - EC2 Instance - Virtual Machine Instance**
1. **Terraform AWS - SSH Key Pair Automatically Created**
1. **Terraform AWS - AWS EC2 docker install - run nginx - Web**
1. **Terraform AWS - AWS EC2 entry-script.sh exec in container**
1. **Terraform AWS - Modules**
---

---
## Step 1 - Terraform Concepts
---
### Terraform
- Tool for Infrastructure Provisioning
- Declarative ( WHAT ) vs Imperative ( HOW )

---
1. AWS Manual steps - Provisioning Infraestructure ( Terraform )
 1. private network space
 1. EC2 server instance
 1. install Docker and other tools
 1. Security
1. AWS Manual steps - Deploying Application ( Ansible )

---
- Create Infraestructure
- Change Infraestructure
- Replication Infraestructure ( dev, stage, prod )

---
- Terraforms Core
 - tf-config
 - State
 - Plan, create/update/destroy
 - Providers, AWS, Azure IaaS / Kubernetes PaaS / Fastly SaaS

---
- Example Config file

```
# Configure the AWS Provider
provider "aws" {
  version = "~> 2.0"
  region = "us-east-2"
}
# Create VPC
resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"
}
```

```
# Configure the Kubernetes Provider
provider "kubernetes" {
  config_context_auth_info = "ops"
  config_context_cluster = "mycluster"
}
# 
resource "kubernetes_namespace" "example" {
  metadata {
    name = "my-first-namespace"
  }
}
```

---
- Terraforms commands

- refresh
- plan 
- apply
- destroy

---
- Key Takeaways

- Universal IaC tool
- differents cloud providers
- differents technologies

---
## Step 2 - Terraform Install local
---
- Install Terraform
```
root@instrument:~# curl -fsSL https://apt.releases.hashicorp.com/gpg |  apt-key add -
OK
 
root@instrument:~#  apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"

root@instrument:~# apt -y update

root@instrument:~# apt install terraform

:~/projects/weekly31$ terraform -version
Terraform v0.14.7
```
---
- Terraform by Example - AWS 

- Creating a Project
```
:~/projects/weekly31$ mkdir terraform
:~/projects/weekly31$ cd terraform/
:~/projects/weekly31/terraform$ touch main.tf
```

- Create de AWS Free Tier Root Account, with Credit Card verification
- Create User with Admin Role, to manage users and resources.
- Save aws credentials.csv

---
## Step 3 - Terraform Provider List
---
- Looking for a Provider in terraform page

https://registry.terraform.io/providers/hashicorp/aws/latest


---
## Step 4 - Terraform Provider connect with AWS

terraform/main.tf
```
provider "aws" {
  region = "us-east-2"
  access_key = ""
  secret_key = ""
}

```
---
## Step 5 - Terraform Provider Install AWS

```
:~/projects/weekly31/terraform$ terraform init

Initializing the backend...

Initializing provider plugins...
- Finding latest version of hashicorp/aws...
- Installing hashicorp/aws v3.30.0...
- Installed hashicorp/aws v3.30.0 (signed by HashiCorp)

Terraform has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
so that Terraform can guarantee to make the same selections by default when
you run "terraform init" in the future.

Terraform has been successfully initialized!

.terraform.lock.hcl

.terraform/providers/registry.terraform.io/hashicorp/aws/3.30.0/linux_amd64/terraform-provider-aws_v3.30.0_x5
```

---
## Step 6 - Terraform AWS
- Connected to AWS account
- VPC
 - your own isolated network in a Region 
 - ip address range, by default, or you can change it
 - Public IP Address can be created in VPC Service
- Subnet 
 - SubNetworks or components on the VPC 
 - a private network inside the network
- Internet Gateway, Security Group
 - Internet Gateway connects the VPC to the outside internet

- NACL - Network Access Control List ( firewall rules )
- Security Group - Control Access over Virtual Machine Network

---
## Step 7 - Terraform AWS - Create VPC - private net/subnet

- terraform/main.tf
```t
provider "aws" {
  region = "us-east-2"
  access_key = "A..."
  secret_key = "S..."
}

resource "aws_vpc" "dev-vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "dev-subnet-1" {
  vpc_id = aws_vpc.dev-vpc.id
  cidr_block = "10.0.10.0/24"
  availability_zone = "us-east-2a"
}
```
- Create - Plan and Apply
```
:~/projects/weekly31/terraform$ terraform apply
```
- Destroy - Plan and Delete/Erase resources
```
:~/projects/weekly31/terraform$ terraform destroy
```
---
## Step 8 - Terraform AWS - Data Sources

- resource {} Create
- data {} defines variables or obtain references

- terraform/main.tf
```t
provider "aws" {
  region = "us-east-2"
  access_key = ""
  secret_key = ""
}
resource "aws_vpc" "dev-vpc" {
  cidr_block = "10.0.0.0/16"
}
resource "aws_subnet" "dev-subnet-1" {
  vpc_id = aws_vpc.dev-vpc.id
  cidr_block = "10.0.10.0/24"
  availability_zone = "us-east-2a"
}
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc
data "aws_vpc" "existing_vpc" {
  default = true
}
resource "aws_subnet" "dev-subnet-2" {
  vpc_id = data.aws_vpc.existing_vpc.id
  cidr_block = "172.31.48.0/20"
  availability_zone = "us-east-2a"
}
```

- Create - Plan and Apply
```
:~/projects/weekly31/terraform$ terraform apply
```
- Destroy - Plan and Delete/Erase resources
```
:~/projects/weekly31/terraform$ terraform destroy
```

---
## Step 9 - Terraform AWS - Change Resources

- Terraform AWS - add Tags, Name, variables myKey, myValue
```t
provider "aws" {
  region = "us-east-2"
  access_key = ""
  secret_key = ""
}

resource "aws_vpc" "dev-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name: "dev",
    vpc_env: "dev"
  }
}

resource "aws_subnet" "dev-subnet-1" {
  vpc_id = aws_vpc.dev-vpc.id
  cidr_block = "10.0.10.0/24"
  availability_zone = "us-east-2a"
  tags = {
    Name: "dev-subnet-1"
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc
data "aws_vpc" "existing_vpc" {
  default = true
}

resource "aws_subnet" "dev-subnet-2" {
  vpc_id = data.aws_vpc.existing_vpc.id
  cidr_block = "172.31.48.0/20"
  availability_zone = "us-east-2a"
  tags = {
    Name: "default-subnet-2"
  }
}
```

---
## Step 10 - Terraform AWS - non-interactive, scriptable

- Auto confirm, non-interactive
```
:~/projects/weekly31/terraform$ terraform apply -auto-approve

:~/projects/weekly31/terraform$ terraform destroy -auto-approve
```

---
## Step 11 - Terraform AWS - State

- terraform.tfstate
- terraform.tfstate.backup

```
:~/projects/weekly31/terraform$ terraform state
```

```
:~/projects/weekly31/terraform$ terraform state list
data.aws_vpc.existing_vpc
aws_subnet.dev-subnet-1
aws_subnet.dev-subnet-2
aws_vpc.dev-vpc
:~/projects/weekly31/terraform$ terraform state show aws_subnet.dev-subnet-1
# aws_subnet.dev-subnet-1:
resource "aws_subnet" "dev-subnet-1" {
    arn                             = "arn:aws:ec2:us-east-2:620157586684:subnet/subnet-0ff55936407cd1ee8"
    assign_ipv6_address_on_creation = false
    availability_zone               = "us-east-2a"
    availability_zone_id            = "use2-az1"
    cidr_block                      = "10.0.10.0/24"
    id                              = "subnet-0ff55936407cd1ee8"
    map_customer_owned_ip_on_launch = false
    map_public_ip_on_launch         = false
    owner_id                        = "620157586684"
    tags                            = {
        "Name" = "dev-subnet-1"
    }
    vpc_id                          = "vpc-07ca76ff9c07a2b71"
}
```

---
## Step 12 - Terraform AWS - Output

- terraform/main.tf
```t
provider "aws" {
  region = "us-east-2"
  access_key = ""
  secret_key = ""
}
resource "aws_vpc" "dev-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name: "dev",
    vpc_env: "dev"
  }
}
resource "aws_subnet" "dev-subnet-1" {
  vpc_id = aws_vpc.dev-vpc.id
  cidr_block = "10.0.10.0/24"
  availability_zone = "us-east-2a"
  tags = {
    Name: "dev-subnet-1"
  }
}
output "dev-vpc-id" {
  value = aws_vpc.dev-vpc.id
}
output "dev-subnet-id" {
  value = aws_subnet.dev-subnet-1.id
}
```
- output
```
:~/projects/weekly31/terraform$ terraform apply -auto-approve
aws_vpc.dev-vpc: Creating...
aws_vpc.dev-vpc: Creation complete after 9s [id=vpc-0174caf836d3e5abf]
aws_subnet.dev-subnet-1: Creating...
aws_subnet.dev-subnet-1: Creation complete after 3s [id=subnet-073b7323e53780da8]

Apply complete! Resources: 2 added, 0 changed, 0 destroyed.

Outputs:

dev-subnet-id = "subnet-073b7323e53780da8"
dev-vpc-id = "vpc-0174caf836d3e5abf"
```

---
## Step 13 - Terraform AWS - Input variables

- terraform/main.tf input variables
```t
provider "aws" {
  region = "us-east-2"
  access_key = ""
  secret_key = ""
}
variable "subnet_cidr_block" {
  description = "subnet cidr block"
}
resource "aws_vpc" "dev-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name: "dev",
    vpc_env: "dev"
  }
}
resource "aws_subnet" "dev-subnet-1" {
  vpc_id = aws_vpc.dev-vpc.id
  cidr_block = var.subnet_cidr_block
  availability_zone = "us-east-2a"
  tags = {
    Name: "dev-subnet-1"
  }
}
```

```
:~/projects/weekly31/terraform$ terraform apply -var "subnet_cidr_block=10.0.30.0/24" -auto-approve
```

### Best Practice - Terraform Variable File terraform.tfvars

- terraform/main.tf
```t
provider "aws" {
  region = "us-east-2"
  access_key = ""
  secret_key = ""
}
variable "subnet_cidr_block" {
  description = "subnet cidr block"
}
resource "aws_vpc" "dev-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name: "dev",
    vpc_env: "dev"
  }
}
resource "aws_subnet" "dev-subnet-1" {
  vpc_id = aws_vpc.dev-vpc.id
  cidr_block = var.subnet_cidr_block
  availability_zone = "us-east-2a"
  tags = {
    Name: "dev-subnet-1"
  }
}
```
- terraform/terraform.tfvars
```
subnet_cidr_block = "10.0.40.0/24"
```

```
:~/projects/weekly31/terraform$ terraform apply -auto-approve
:~/projects/weekly31/terraform$ terraform destroy -auto-approve
```

---
## Step 14 - Terraform AWS - Environment Config File, dev, staging, prod.

- terraform/main.tf
```t
provider "aws" {
  region = "us-east-2"
  access_key = ""
  secret_key = ""
}
variable "subnet_cidr_block" {
  description = "subnet cidr block"
}
variable "vpc_cidr_block" {
  description = "vpc cidr block"
}
variable "env" {
  description = "deployment environment"
}
resource "aws_vpc" "dev-vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name: var.env,
    vpc_env: "dev"
  }
}
resource "aws_subnet" "dev-subnet-1" {
  vpc_id = aws_vpc.dev-vpc.id
  cidr_block = var.subnet_cidr_block
  availability_zone = "us-east-2a"
  tags = {
    Name: "dev-subnet-1"
  }
}
```
- terraform/terraform-dev.tfvars
```t
subnet_cidr_block = "10.0.40.0/24"
vpc_cidr_block = "10.0.0.0/16"
env = "dev"
```

```
:~/projects/weekly31/terraform$ terraform apply -var-file terraform-dev.tfvars -auto-approve

:~/projects/weekly31/terraform$ terraform destroy -var-file terraform-dev.tfvars -auto-approve
```

---
## Step 15 - Terraform AWS - Variable Default Values

```t
...
variable "subnet_cidr_block" {
  description = "subnet cidr block"
  default = "10.0.10.0/24"
}
...
```
---
## Step 15 - Terraform AWS - Variable Types

```t
...
variable "subnet_cidr_block" {
  description = "subnet cidr block"
  default = "10.0.10.0/24"
  type = string
}
...
```
---
## Step 16 - Terraform AWS - Environment Variables

AWS_ACCESS_KEY_ID..

AWS_SECRET_ACCESS_KEY..

#### the better way
- AWS default access globaly for this user.
```
:~/projects/weekly31/terraform$ cat ~/.aws/credentials 
[default]
aws_access_key_id = A..
aws_secret_access_key = S..
```
- AWS generation code was over
```
$ aws configure
```

#### other ways Terraform Custom Environment Variables

```
$ export TF_VAR_avail_zone="us-east-2"
```

```t
variable avail_zone {}
...
      availability_zone = var.avail_zone

```

---
## Step 17 - Terraform AWS - Base Project

1. VPC - Create
1. Subnet - Create
1. Rute Tables & Internet Gateway - Create
1. Provision EC2 Instance
1. Deploy Docker Container with Nginx - Simple
1. Security Group - Create ( Firewall )

### Terraform: Best Practice, Create Infraestructure from Scratch!!

---
## Step 18 - Terraform AWS - VPC & Subnet

- terraform/main.tf
```t
provider "aws" {
  region = "us-east-2"
}
variable vpc_cidr_block {}
variable subnet_cidr_block {}
variable avail_zone {}
variable env_prefix {}
resource "aws_vpc" "myapp-vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name: "${var.env_prefix}-vpc"
  }
}
resource "aws_subnet" "myapp-subnet-1" {
  vpc_id = aws_vpc.myapp-vpc.id
  cidr_block = var.subnet_cidr_block
  availability_zone = var.avail_zone
  tags = {
    Name: "${var.env_prefix}-subnet-1"
  }
}
```

- terraform/terraform.tfvars
```t
vpc_cidr_block = "10.0.0.0/16"
subnet_cidr_block = "10.0.10.0/24"
avail_zone = "us-east-2a"
env_prefix = "dev"
```
- Create and Destroy
```
:~/projects/weekly31/terraform$ terraform apply -auto-approve
:~/projects/weekly31/terraform$ terraform destroy -auto-approve
```

---
## Step 19 - Terraform AWS - Create Route Table & Internet Gateway

- terraform/main.tf
```t
provider "aws" {
  region = "us-east-2"
}
variable vpc_cidr_block {}
variable subnet_cidr_block {}
variable avail_zone {}
variable env_prefix {}
resource "aws_vpc" "myapp-vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name: "${var.env_prefix}-vpc"
  }
}
resource "aws_subnet" "myapp-subnet-1" {
  vpc_id = aws_vpc.myapp-vpc.id
  cidr_block = var.subnet_cidr_block
  availability_zone = var.avail_zone
  tags = {
    Name: "${var.env_prefix}-subnet-1"
  }
}
resource "aws_route_table" "myapp-route-table" {
  vpc_id = aws_vpc.myapp-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myapp-igw.id
  }
  tags = {
    Name: "${var.env_prefix}-rtb"
  }
}
resource "aws_internet_gateway" "myapp-igw" {
  vpc_id = aws_vpc.myapp-vpc.id
  tags = {
    Name: "${var.env_prefix}-igw"
  }
}
```

- Create, and result
```
:~/projects/weekly31/terraform$ terraform apply -auto-approve
aws_vpc.myapp-vpc: Creating...
aws_vpc.myapp-vpc: Creation complete after 9s [id=vpc-0108b14e27b53830c]
aws_internet_gateway.myapp-igw: Creating...
aws_subnet.myapp-subnet-1: Creating...
aws_subnet.myapp-subnet-1: Creation complete after 3s [id=subnet-01cab13c129b0cfc5]
aws_internet_gateway.myapp-igw: Creation complete after 5s [id=igw-0f0f08b3b4e89392d]
aws_route_table.myapp-route-table: Creating...
aws_route_table.myapp-route-table: Creation complete after 4s [id=rtb-01c0552c2a50cb98a]

Apply complete! Resources: 4 added, 0 changed, 0 destroyed.
```
- Clean AWS Resources
```
:~/projects/weekly31/terraform$ terraform destroy -auto-approve
```
---
## Step 20 - Terraform AWS - Route Table Association

- terraform/main.tf
```t
provider "aws" {
  region = "us-east-2"
}
variable vpc_cidr_block {}
variable subnet_cidr_block {}
variable avail_zone {}
variable env_prefix {}
resource "aws_vpc" "myapp-vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name: "${var.env_prefix}-vpc"
  }
}
resource "aws_subnet" "myapp-subnet-1" {
  vpc_id = aws_vpc.myapp-vpc.id
  cidr_block = var.subnet_cidr_block
  availability_zone = var.avail_zone
  tags = {
    Name: "${var.env_prefix}-subnet-1"
  }
}
resource "aws_route_table" "myapp-route-table" {
  vpc_id = aws_vpc.myapp-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myapp-igw.id
  }
  tags = {
    Name: "${var.env_prefix}-rtb"
  }
}
resource "aws_internet_gateway" "myapp-igw" {
  vpc_id = aws_vpc.myapp-vpc.id
  tags = {
    Name: "${var.env_prefix}-igw"
  }
}
resource "aws_route_table_association" "a-rtb-subnet" {
  subnet_id = aws_subnet.myapp-subnet-1.id
  route_table_id = aws_route_table.myapp-route-table.id
}
```
- Create AWS Resources, Terraform Apply
```
:~/projects/weekly31/terraform$ terraform apply --auto-approve
aws_vpc.myapp-vpc: Creating...
aws_vpc.myapp-vpc: Still creating... [10s elapsed]
aws_vpc.myapp-vpc: Still creating... [20s elapsed]
aws_vpc.myapp-vpc: Creation complete after 20s [id=vpc-09ab4467b1c391489]
aws_internet_gateway.myapp-igw: Creating...
aws_subnet.myapp-subnet-1: Creating...
aws_subnet.myapp-subnet-1: Creation complete after 3s [id=subnet-0682240329ac990ad]
aws_internet_gateway.myapp-igw: Creation complete after 5s [id=igw-036a3d630f8cd3758]
aws_route_table.myapp-route-table: Creating...
aws_route_table.myapp-route-table: Creation complete after 5s [id=rtb-0d0748b97c09641f7]
aws_route_table_association.a-rtb-subnet: Creating...
aws_route_table_association.a-rtb-subnet: Creation complete after 2s [id=rtbassoc-0effeeae45c939d4e]

Apply complete! Resources: 5 added, 0 changed, 0 destroyed.
```
- Clean AWS resources
```
:~/projects/weekly31/terraform$ terraform destroy --auto-approve
```

---
## Step 21 - Terraform AWS - Security Group

- https://www.whatsmyip.org/

-terraform/terraform.tfvars
```t
vpc_cidr_block = "10.0.0.0/16"
subnet_cidr_block = "10.0.10.0/24"
avail_zone = "us-east-2a"
env_prefix = "dev"
my_ip = "181.44.61.193/32"
```
- terraform/main.tf
```t
provider "aws" {
  region = "us-east-2"
}
variable vpc_cidr_block {}
variable subnet_cidr_block {}
variable avail_zone {}
variable env_prefix {}
variable my_ip {}
resource "aws_vpc" "myapp-vpc" {
  cidr_block = var.vpc_cidr_block
  tags = { Name: "${var.env_prefix}-vpc" }
}
resource "aws_subnet" "myapp-subnet-1" {
  vpc_id = aws_vpc.myapp-vpc.id
  cidr_block = var.subnet_cidr_block
  availability_zone = var.avail_zone
  tags = {  Name: "${var.env_prefix}-subnet-1" }
}
resource "aws_route_table" "myapp-route-table" {
  vpc_id = aws_vpc.myapp-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myapp-igw.id
  }
  tags = { Name: "${var.env_prefix}-rtb" }
}
resource "aws_internet_gateway" "myapp-igw" {
  vpc_id = aws_vpc.myapp-vpc.id
  tags = { Name: "${var.env_prefix}-igw" }
}
resource "aws_route_table_association" "a-rtb-subnet" {
  subnet_id = aws_subnet.myapp-subnet-1.id
  route_table_id = aws_route_table.myapp-route-table.id
}
resource "aws_security_group" "myapp-sg" {
  name = "myapp-sg"
  vpc_id = aws_vpc.myapp-vpc.id
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [var.my_ip]
  }
  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    prefix_list_ids = []
  }
  tags = { Name: "${var.env_prefix}-sg" }
}
```
- Create AWS Resources, Terraform Apply
```
:~/projects/weekly31/terraform$ terraform apply --auto-approve
aws_vpc.myapp-vpc: Creating...
aws_vpc.myapp-vpc: Creation complete after 10s [id=vpc-055f4424f5c9d6e4a]
aws_internet_gateway.myapp-igw: Creating...
aws_subnet.myapp-subnet-1: Creating...
aws_security_group.myapp-sg: Creating...
aws_subnet.myapp-subnet-1: Creation complete after 3s [id=subnet-0cdda69b8346374aa]
aws_internet_gateway.myapp-igw: Creation complete after 4s [id=igw-0246b73e2db31e0ee]
aws_route_table.myapp-route-table: Creating...
aws_security_group.myapp-sg: Creation complete after 7s [id=sg-0a6153d7c860ff6f7]
aws_route_table.myapp-route-table: Creation complete after 4s [id=rtb-0c804a1710aa074e7]
aws_route_table_association.a-rtb-subnet: Creating...
aws_route_table_association.a-rtb-subnet: Creation complete after 1s [id=rtbassoc-06b86135af1cee7e3]

Apply complete! Resources: 6 added, 0 changed, 0 destroyed.
```
- Clean AWS resources
```
:~/projects/weekly31/terraform$ terraform destroy --auto-approve
```

---
## Step 22 - Terraform AWS - Obtain Imange Id Dinamically from AWS

- terraform/main.tf test ami data value obtained dinamically
```t
provider "aws" {
  region = "us-east-2"
}
variable vpc_cidr_block {}
variable subnet_cidr_block {}
variable avail_zone {}
variable env_prefix {}
variable my_ip {}
resource "aws_vpc" "myapp-vpc" {
  cidr_block = var.vpc_cidr_block
  tags = { Name: "${var.env_prefix}-vpc" }
}
resource "aws_subnet" "myapp-subnet-1" {
  vpc_id = aws_vpc.myapp-vpc.id
  cidr_block = var.subnet_cidr_block
  availability_zone = var.avail_zone
  tags = {  Name: "${var.env_prefix}-subnet-1" }
}
resource "aws_route_table" "myapp-route-table" {
  vpc_id = aws_vpc.myapp-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myapp-igw.id
  }
  tags = { Name: "${var.env_prefix}-rtb" }
}
resource "aws_internet_gateway" "myapp-igw" {
  vpc_id = aws_vpc.myapp-vpc.id
  tags = { Name: "${var.env_prefix}-igw" }
}
resource "aws_route_table_association" "a-rtb-subnet" {
  subnet_id = aws_subnet.myapp-subnet-1.id
  route_table_id = aws_route_table.myapp-route-table.id
}
resource "aws_security_group" "myapp-sg" {
  name = "myapp-sg"
  vpc_id = aws_vpc.myapp-vpc.id
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [var.my_ip]
  }
  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    prefix_list_ids = []
  }
  tags = { Name: "${var.env_prefix}-sg" }
}
data "aws_ami" "latest-amazon-linux-image" {
  most_recent = true
  owners = ["amazon"]
  filter {
    name = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
}
output "aws_ami_id" {
  value = data.aws_ami.latest-amazon-linux-image.id
}
/*resource "aws_instance" "myapp-server" {
  ami = data.aws_ami.latest-amazon-linux-image.id
}*/
```
- Test AWS Image Id Dinamically Obtained 
```
:~/projects/weekly31/terraform$ terraform plan

...
Changes to Outputs:
  + aws_ami_id = "ami-09246ddb00c7c4fef"

```

---
## Step 23 - Terraform AWS - EC2 Instance - Virtual Machine Instance

- **In AWS Console - Create and Download Key Pair .pem file to have ssh access**
- **mv ~/Downloads/aws-server-key-pair.pem ~/.ssh**
- **chmod 400 ~/.ssh/aws-server-key-pair.pem**
- **-r--------   aws-server-key-pair.pem**

- terraform/main.tf
```t
provider "aws" {
  region = "us-east-2"
}
variable vpc_cidr_block {}
variable subnet_cidr_block {}
variable avail_zone {}
variable env_prefix {}
variable my_ip {}
variable instance_type {}
resource "aws_vpc" "myapp-vpc" {
  cidr_block = var.vpc_cidr_block
  tags = { Name: "${var.env_prefix}-vpc" }
}
resource "aws_subnet" "myapp-subnet-1" {
  vpc_id = aws_vpc.myapp-vpc.id
  cidr_block = var.subnet_cidr_block
  availability_zone = var.avail_zone
  tags = {  Name: "${var.env_prefix}-subnet-1" }
}
resource "aws_route_table" "myapp-route-table" {
  vpc_id = aws_vpc.myapp-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myapp-igw.id
  }
  tags = { Name: "${var.env_prefix}-rtb" }
}
resource "aws_internet_gateway" "myapp-igw" {
  vpc_id = aws_vpc.myapp-vpc.id
  tags = { Name: "${var.env_prefix}-igw" }
}
resource "aws_route_table_association" "a-rtb-subnet" {
  subnet_id = aws_subnet.myapp-subnet-1.id
  route_table_id = aws_route_table.myapp-route-table.id
}
resource "aws_security_group" "myapp-sg" {
  name = "myapp-sg"
  vpc_id = aws_vpc.myapp-vpc.id
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [var.my_ip]
  }
  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    prefix_list_ids = []
  }
  tags = { Name: "${var.env_prefix}-sg" }
}
data "aws_ami" "latest-amazon-linux-image" {
  most_recent = true
  owners = ["amazon"]
  filter {
    name = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
}
output "aws_ami_id" {
  value = data.aws_ami.latest-amazon-linux-image
}
resource "aws_instance" "myapp-server" {
  ami = data.aws_ami.latest-amazon-linux-image.id
  instance_type = var.instance_type
  subnet_id = aws_subnet.myapp-subnet-1.id
  vpc_security_group_ids = [ aws_security_group.myapp-sg.id ]
  availability_zone = var.avail_zone
  associate_public_ip_address = true
  key_name = "aws-server-key-pair"
  tags = { Name: "${var.env_prefix}-server" }
}
```

- ssh access ( using ssh credentials public .pem file created UI AWS Console )
```
:~/projects/weekly31/terraform$ ssh -i ~/.ssh/aws-server-key-pair.pem ec2-user@3.135.218.233
The authenticity of host '3.135.218.233 (3.135.218.233)' can't be established.
ECDSA key fingerprint is SHA256:6KJ9uOKJ4SvAWEieJ3M+oLBY/UAd79Orq1RS44J2fDI.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added '3.135.218.233' (ECDSA) to the list of known hosts.

       __|  __|_  )
       _|  (     /   Amazon Linux 2 AMI
      ___|\___|___|

https://aws.amazon.com/amazon-linux-2/
[ec2-user@ip-10-0-10-198 ~]$ 
```

---
## Step 23 - Terraform AWS - SSH Key Pair Automatically Created

- **ssh-keygen**
- **~/.ssh/id_rsa.pub**

- terraform/terraform.tfvars
```js
vpc_cidr_block = "10.0.0.0/16"
subnet_cidr_block = "10.0.10.0/24"
avail_zone = "us-east-2a"
env_prefix = "dev"
my_ip = "181.44.61.193/32"
instance_type = "t2.micro"
my_public_key_location = "/home/maximilianou/.ssh/id_rsa.pub"
```
- terraform/main.tf
```js
provider "aws" {
  region = "us-east-2"
}
variable vpc_cidr_block {}
variable subnet_cidr_block {}
variable avail_zone {}
variable env_prefix {}
variable my_ip {}
variable instance_type {}
variable my_public_key_location {}
resource "aws_vpc" "myapp-vpc" {
  cidr_block = var.vpc_cidr_block
  tags = { Name: "${var.env_prefix}-vpc" }
}
resource "aws_subnet" "myapp-subnet-1" {
  vpc_id = aws_vpc.myapp-vpc.id
  cidr_block = var.subnet_cidr_block
  availability_zone = var.avail_zone
  tags = {  Name: "${var.env_prefix}-subnet-1" }
}
resource "aws_route_table" "myapp-route-table" {
  vpc_id = aws_vpc.myapp-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myapp-igw.id
  }
  tags = { Name: "${var.env_prefix}-rtb" }
}
resource "aws_internet_gateway" "myapp-igw" {
  vpc_id = aws_vpc.myapp-vpc.id
  tags = { Name: "${var.env_prefix}-igw" }
}
resource "aws_route_table_association" "a-rtb-subnet" {
  subnet_id = aws_subnet.myapp-subnet-1.id
  route_table_id = aws_route_table.myapp-route-table.id
}
resource "aws_security_group" "myapp-sg" {
  name = "myapp-sg"
  vpc_id = aws_vpc.myapp-vpc.id
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [var.my_ip]
  }
  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    prefix_list_ids = []
  }
  tags = { Name: "${var.env_prefix}-sg" }
}
data "aws_ami" "latest-amazon-linux-image" {
  most_recent = true
  owners = ["amazon"]
  filter {
    name = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
}
output "aws_ami_id" {
  value = data.aws_ami.latest-amazon-linux-image
}
output "aws_ec2_public_ip" {
  value = aws_instance.myapp-server.public_ip
}
resource "aws_key_pair" "ssh-key" {
  key_name = "aws-server-key"
  public_key = file(var.my_public_key_location)
}
resource "aws_instance" "myapp-server" {
  ami = data.aws_ami.latest-amazon-linux-image.id
  instance_type = var.instance_type
  subnet_id = aws_subnet.myapp-subnet-1.id
  vpc_security_group_ids = [ aws_security_group.myapp-sg.id ]
  availability_zone = var.avail_zone
  associate_public_ip_address = true
  key_name = aws_key_pair.ssh-key.key_name
  tags = { Name: "${var.env_prefix}-server" }
}
```
- ssh verbose access server default ssh keys local user.
```js
aws_ec2_public_ip = "3.15.143.45"
:~/projects/weekly31/terraform$ ssh -vvv -i ~/.ssh/id_rsa ec2-user@3.15.143.45
...

       __|  __|_  )
       _|  (     /   Amazon Linux 2 AMI
      ___|\___|___|

https://aws.amazon.com/amazon-linux-2/
[ec2-user@ip-10-0-10-210 ~]$ 
```
- ssh default local
```js
:~/projects/weekly31/terraform$ ssh ec2-user@3.15.143.45
Last login: Wed Mar  3 19:26:35 2021 from 181.44.61.193

       __|  __|_  )
       _|  (     /   Amazon Linux 2 AMI
      ___|\___|___|

https://aws.amazon.com/amazon-linux-2/
[ec2-user@ip-10-0-10-210 ~]$ exit
logout
Connection to 3.15.143.45 closed.
```

---
---
## Step 24 - Terraform AWS - AWS EC2 docker install - run nginx

- terraform/main.tf
```js
provider "aws" {
  region = "us-east-2"
}
variable vpc_cidr_block {}
variable subnet_cidr_block {}
variable avail_zone {}
variable env_prefix {}
variable my_ip {}
variable instance_type {}
variable my_public_key_location {}
resource "aws_vpc" "myapp-vpc" {
  cidr_block = var.vpc_cidr_block
  tags = { Name: "${var.env_prefix}-vpc" }
}
resource "aws_subnet" "myapp-subnet-1" {
  vpc_id = aws_vpc.myapp-vpc.id
  cidr_block = var.subnet_cidr_block
  availability_zone = var.avail_zone
  tags = {  Name: "${var.env_prefix}-subnet-1" }
}
resource "aws_route_table" "myapp-route-table" {
  vpc_id = aws_vpc.myapp-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myapp-igw.id
  }
  tags = { Name: "${var.env_prefix}-rtb" }
}
resource "aws_internet_gateway" "myapp-igw" {
  vpc_id = aws_vpc.myapp-vpc.id
  tags = { Name: "${var.env_prefix}-igw" }
}
resource "aws_route_table_association" "a-rtb-subnet" {
  subnet_id = aws_subnet.myapp-subnet-1.id
  route_table_id = aws_route_table.myapp-route-table.id
}
resource "aws_security_group" "myapp-sg" {
  name = "myapp-sg"
  vpc_id = aws_vpc.myapp-vpc.id
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [var.my_ip]
  }
  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    prefix_list_ids = []
  }
  tags = { Name: "${var.env_prefix}-sg" }
}
data "aws_ami" "latest-amazon-linux-image" {
  most_recent = true
  owners = ["amazon"]
  filter {
    name = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
}
output "aws_ami_id" {
  value = data.aws_ami.latest-amazon-linux-image
}
output "aws_ec2_public_ip" {
  value = aws_instance.myapp-server.public_ip
}
resource "aws_key_pair" "ssh-key" {
  key_name = "aws-server-key"
  public_key = file(var.my_public_key_location)
}
resource "aws_instance" "myapp-server" {
  ami = data.aws_ami.latest-amazon-linux-image.id
  instance_type = var.instance_type
  subnet_id = aws_subnet.myapp-subnet-1.id
  vpc_security_group_ids = [ aws_security_group.myapp-sg.id ]
  availability_zone = var.avail_zone
  associate_public_ip_address = true
  key_name = aws_key_pair.ssh-key.key_name
  user_data = <<EOF
                  #!/bin/bash
                  sudo yum -y update && sudo yum -y install docker
                  sudo systemctl start docker
                  sudo usermod -aG docker ec2-user
                  docker run -p 8080:80 nginx 

              EOF
  tags = { Name: "${var.env_prefix}-server" }
}
```

```
:~/projects/weekly31/terraform$ terraform apply --auto-approve
```

```
aws_ec2_public_ip = "3.16.50.58"
:~/projects/weekly31/terraform$ ssh ec2-user@3.16.50.58
Last login: Wed Mar  3 20:30:01 2021 from 181.44.61.193

       __|  __|_  )
       _|  (     /   Amazon Linux 2 AMI
      ___|\___|___|

https://aws.amazon.com/amazon-linux-2/
[ec2-user@ip-10-0-10-183 ~]$ docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED              STATUS              PORTS                  NAMES
2bc93973a6cb        nginx               "/docker-entrypoint.…"   About a minute ago   Up About a minute   0.0.0.0:8080->80/tcp   gifted_fermat
```
- http://3.16.50.58:8080/

```
:~/projects/weekly31/terraform$ terraform destroy --auto-approve
```

---
## Step 25 - Terraform AWS - AWS EC2 entry-script.sh exec in container

- terraform/main.tf
```js
provider "aws" {
  region = "us-east-2"
}
variable vpc_cidr_block {}
variable subnet_cidr_block {}
variable avail_zone {}
variable env_prefix {}
variable my_ip {}
variable instance_type {}
variable my_public_key_location {}
resource "aws_vpc" "myapp-vpc" {
  cidr_block = var.vpc_cidr_block
  tags = { Name: "${var.env_prefix}-vpc" }
}
resource "aws_subnet" "myapp-subnet-1" {
  vpc_id = aws_vpc.myapp-vpc.id
  cidr_block = var.subnet_cidr_block
  availability_zone = var.avail_zone
  tags = {  Name: "${var.env_prefix}-subnet-1" }
}
resource "aws_route_table" "myapp-route-table" {
  vpc_id = aws_vpc.myapp-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myapp-igw.id
  }
  tags = { Name: "${var.env_prefix}-rtb" }
}
resource "aws_internet_gateway" "myapp-igw" {
  vpc_id = aws_vpc.myapp-vpc.id
  tags = { Name: "${var.env_prefix}-igw" }
}
resource "aws_route_table_association" "a-rtb-subnet" {
  subnet_id = aws_subnet.myapp-subnet-1.id
  route_table_id = aws_route_table.myapp-route-table.id
}
resource "aws_security_group" "myapp-sg" {
  name = "myapp-sg"
  vpc_id = aws_vpc.myapp-vpc.id
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [var.my_ip]
  }
  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    prefix_list_ids = []
  }
  tags = { Name: "${var.env_prefix}-sg" }
}
data "aws_ami" "latest-amazon-linux-image" {
  most_recent = true
  owners = ["amazon"]
  filter {
    name = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
}
output "aws_ami_id" {
  value = data.aws_ami.latest-amazon-linux-image
}
output "aws_ec2_public_ip" {
  value = aws_instance.myapp-server.public_ip
}
resource "aws_key_pair" "ssh-key" {
  key_name = "aws-server-key"
  public_key = file(var.my_public_key_location)
}
resource "aws_instance" "myapp-server" {
  ami = data.aws_ami.latest-amazon-linux-image.id
  instance_type = var.instance_type
  subnet_id = aws_subnet.myapp-subnet-1.id
  vpc_security_group_ids = [ aws_security_group.myapp-sg.id ]
  availability_zone = var.avail_zone
  associate_public_ip_address = true
  key_name = aws_key_pair.ssh-key.key_name
  user_data = file("entry-script.sh")
  tags = { Name: "${var.env_prefix}-server" }
}
```
- terraform/entry-script.sh
```sh
#!/bin/bash
sudo yum -y update && sudo yum -y install docker
sudo systemctl start docker
sudo usermod -aG docker ec2-user
docker run -p 8080:80 nginx
```

---
## Step 26 - Terraform AWS - Provisioners

- Usage is not recommended by Terraform

---
## Step 27 - Terraform AWS - Modules

https://registry.terraform.io/browse/modules

- terraform/main.tf
```js
provider "aws" {
  region = "us-east-2"
}
resource "aws_vpc" "myapp-vpc" {
  cidr_block = var.vpc_cidr_block
  tags = { Name: "${var.env_prefix}-vpc" }
}
resource "aws_subnet" "myapp-subnet-1" {
  vpc_id = aws_vpc.myapp-vpc.id
  cidr_block = var.subnet_cidr_block
  availability_zone = var.avail_zone
  tags = {  Name: "${var.env_prefix}-subnet-1" }
}
resource "aws_route_table" "myapp-route-table" {
  vpc_id = aws_vpc.myapp-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myapp-igw.id
  }
  tags = { Name: "${var.env_prefix}-rtb" }
}
resource "aws_internet_gateway" "myapp-igw" {
  vpc_id = aws_vpc.myapp-vpc.id
  tags = { Name: "${var.env_prefix}-igw" }
}
resource "aws_route_table_association" "a-rtb-subnet" {
  subnet_id = aws_subnet.myapp-subnet-1.id
  route_table_id = aws_route_table.myapp-route-table.id
}
resource "aws_security_group" "myapp-sg" {
  name = "myapp-sg"
  vpc_id = aws_vpc.myapp-vpc.id
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [var.my_ip]
  }
  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    prefix_list_ids = []
  }
  tags = { Name: "${var.env_prefix}-sg" }
}
data "aws_ami" "latest-amazon-linux-image" {
  most_recent = true
  owners = ["amazon"]
  filter {
    name = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
}
resource "aws_key_pair" "ssh-key" {
  key_name = "aws-server-key"
  public_key = file(var.my_public_key_location)
}
resource "aws_instance" "myapp-server" {
  ami = data.aws_ami.latest-amazon-linux-image.id
  instance_type = var.instance_type
  subnet_id = aws_subnet.myapp-subnet-1.id
  vpc_security_group_ids = [ aws_security_group.myapp-sg.id ]
  availability_zone = var.avail_zone
  associate_public_ip_address = true
  key_name = aws_key_pair.ssh-key.key_name
  user_data = file("entry-script.sh")
  tags = { Name: "${var.env_prefix}-server" }
}
```
- terraform/variables.tf
```js
variable vpc_cidr_block {}
variable subnet_cidr_block {}
variable avail_zone {}
variable env_prefix {}
variable my_ip {}
variable instance_type {}
variable my_public_key_location {}
variable my_private_key_location {}
```
- terraform/providers.tf
```js

```
- terraform/outputs.tf
```js
output "aws_ami_id" {
  value = data.aws_ami.latest-amazon-linux-image
}
output "aws_ec2_public_ip" {
  value = aws_instance.myapp-server.public_ip
}
```

```
:~/projects/weekly31/terraform$ terraform apply --auto-approve
```

```
:~/projects/weekly31/terraform$ terraform destroy --auto-approve
```

---
## Step 28 - Terraform AWS - Modules
