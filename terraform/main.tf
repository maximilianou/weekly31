terraform {
  required_version = ">= 0.12"
  backend "s3" {
    bucket = "myapp-terraform-bucket"
    key = "myapp/state.tfstate"
    region = "us-east-2"
  }
}
provider "aws" {
  region = "us-east-2"
}
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  name = "my-vpc"
  cidr = var.vpc_cidr_block
  azs             = [ var.avail_zone ]
  public_subnets  = [ var.subnet_cidr_block ]
  public_subnet_tags = { Name = "${var.env_prefix}-subnet-1"}
  tags = { Name = "${var.env_prefix}-vpc" }
}
module "myapp-server" {
  source = "./modules/webserver"
  vpc_id = module.vpc.vpc_id
  my_ip = var.my_ip
  my_public_key_location = var.my_public_key_location
  instance_type = var.instance_type
  image_name = var.image_name
  subnet_id = module.vpc.public_subnets[0]
  avail_zone = var.avail_zone
  env_prefix = var.env_prefix
}