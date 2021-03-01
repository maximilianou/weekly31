provider "aws" {
  region = "us-east-2"
}
variable "cidr_blocks" {
  description = " cidr blocks list of objects "
  type = list(object({
    cidr_block = string
    name = string
  }))
}
resource "aws_vpc" "dev-vpc" {
  cidr_block = var.cidr_blocks[0].cidr_block
  tags = {
    Name: var.cidr_blocks[0].name
  }
}
resource "aws_subnet" "dev-subnet-1" {
  vpc_id = aws_vpc.dev-vpc.id
  cidr_block = var.cidr_blocks[1].cidr_block
  availability_zone = "us-east-2a"
  tags = {
    Name: var.cidr_blocks[1].name
  }
}

