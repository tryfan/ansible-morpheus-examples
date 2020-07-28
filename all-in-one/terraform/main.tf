provider "aws" {
  version = "~> 2.0"
  region = var.aws_region
}

resource "aws_vpc" "morpheus_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_internet_gateway" "morpheus_igw" {
  vpc_id = aws_vpc.morpheus_vpc.id
}

resource "aws_route" "morpheus_internet_access" {
  route_table_id = aws_vpc.morpheus_vpc.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.morpheus_igw.id
}

resource "aws_subnet" "morpheus_ui_subnet" {
  cidr_block = "10.0.10.0/24"
  vpc_id = aws_vpc.morpheus_vpc.id
  map_public_ip_on_launch = true
}

resource "aws_security_group" "morpheus_ui_web" {
  name = "morpheus_ui_web"
  vpc_id = aws_vpc.morpheus_vpc.id

  ingress {
    from_port = 443
    protocol = "tcp"
    to_port = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "morpheus_ui_mgmt" {
  name = "morpheus_ui_mgmt"
  vpc_id = aws_vpc.morpheus_vpc.id
  ingress {
    from_port = 22
    protocol = "tcp"
    to_port = 22
    cidr_blocks = ["216.8.185.14/32"]
  }
  egress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "auth" {
  public_key = file(var.pubkey_path)
}

resource "aws_instance" "morphui_1" {
//  connection {
//    type = "ssh"
//
//  }

  ami = var.aws_amis[var.aws_region]
  instance_type = "t2.xlarge"
  key_name = aws_key_pair.auth.id
  root_block_device {
    volume_size = 20
  }

  vpc_security_group_ids = [aws_security_group.morpheus_ui_web.id,aws_security_group.morpheus_ui_mgmt.id]
  subnet_id = aws_subnet.morpheus_ui_subnet.id
}