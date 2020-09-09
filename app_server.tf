provider "aws" {
  profile    = "devops"
  region     = "ap-south-1"
}

resource "aws_instance" "app1" {
  ami           = "ami-09a7bbd08886aafdf"
  instance_type = "t2.medium"
  subnet_id     = "${aws_subnet.test_subnet1.id}"
  vpc_security_group_ids      = ["${aws_security_group.group1.id}"]
  key_name = "test-dev"
}
  
resource "aws_subnet" "test_subnet1" {
  cidr_block = "10.2.1.0/24"
  vpc_id = "${aws_vpc.test_vpc.id}"
  availability_zone = "ap-south-1a"

  }

  resource "aws_internet_gateway" "test_igw" {
  vpc_id = "${aws_vpc.test_vpc.id}"
}

resource "aws_route_table" "route_table" {
  vpc_id = "${aws_vpc.test_vpc.id}"
  }

resource "aws_route" "test_route" {
  route_table_id = "${aws_route_table.route_table.id}"
  gateway_id = "${aws_internet_gateway.test_igw.id}"
  destination_cidr_block = "0.0.0.0/0"
  }

resource "aws_route_table_association" "public_route_association" {
  route_table_id = "${aws_route_table.route_table.id}"
  subnet_id     = "${aws_subnet.test_subnet1.id}"
}

resource "aws_vpc" "test_vpc" {
  cidr_block = "10.2.0.0/16"
 }

resource "aws_security_group" "group1" {
   vpc_id = "${aws_vpc.test_vpc.id}"

}

resource "aws_eip" "test_eip" {
  instance = "${aws_instance.app1.id}"
  }

resource "aws_security_group_rule" "test_rule" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["${var.all_ip}"]
  security_group_id = "${aws_security_group.group1.id}"
}

resource "aws_security_group_rule" "app_server_ingress_ssh" {
      from_port         = 22
      protocol          = "tcp"
      security_group_id = "${aws_security_group.group1.id}"
      to_port           = 22
      type              = "ingress"
      cidr_blocks       = ["${var.all_ip}"]
}

resource "aws_security_group_rule" "app_server_ingress_tomcat" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  cidr_blocks       = ["${var.all_ip}"]
  security_group_id = "${aws_security_group.group1.id}"

}
          