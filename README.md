# weekly31

## Terraform - AWS 

---
- TOC
---
1. **Terraform**
---

### Terraform
- Tool for Infrastructure Provisioning
- Declarative ( WHAT ) vs Imperative ( HOW )

1. AWS Manual steps - Provisioning Infraestructure ( Terraform )
 1. private network space
 1. EC2 server instance
 1. install Docker and other tools
 1. Security
1. AWS Manual steps - Deploying Application ( Ansible )

- Create Infraestructure
- Change Infraestructure
- Replication Infraestructure ( dev, stage, prod )

- Terraforms Core
 - tf-config
 - State
 - Plan, create/update/destroy
 - Providers, AWS, Azure IaaS / Kubernetes PaaS / Fastly SaaS

---

Example Config file

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