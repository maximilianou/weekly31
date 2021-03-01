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

