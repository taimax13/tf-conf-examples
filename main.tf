//define the provider
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      //version = "~> 3.0" -> this is optional param
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
  access_key="AKIAQXR7H5HP6FDUERNS"  #this keys is not active
  secret_key="yTfXvDK1/lEkceP5yrRXdT8iWBQxa0WNUk3l/d39" ## and used as example
}

resource "aws_vpc" "test_vpc" {
  cidr_block = "172.16.0.0/16"

  tags = {
    Name = "tf-example"
  }
}

resource "aws_subnet" "test_subnet" {
  vpc_id            = aws_vpc.test_vpc.id
  cidr_block        = "172.16.10.0/24"
  availability_zone = "us-west-2a"

  tags = {
    Name = "tf-example"
  }
}

resource "aws_network_interface" "test_network_interface" {
  subnet_id   = aws_subnet.test_subnet.id
  private_ips = ["172.16.10.100"]

  tags = {
    Name = "primary_network_interface"
  }
}

resource "aws_instance" "test-instance" {
  ami           = "ami-026a886b" 
  instance_type = "t2.micro"

  network_interface {
    network_interface_id = aws_network_interface.test_network_interface.id
    device_index         = 0
  }
}
