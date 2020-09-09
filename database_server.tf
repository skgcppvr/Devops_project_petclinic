resource "aws_instance" "database" {
  ami           = "ami-09a7bbd08886aafdf"
  instance_type = "t2.micro"
  subnet_id     = "${aws_subnet.test_subnet1.id}"
  vpc_security_group_ids      = ["${aws_security_group.group2.id}"]
  key_name = "test-dev"
}

#resource "aws_subnet" "test_subnet2" {
#cidr_block = "10.2.2.0/24"
 #vpc_id = "${aws_vpc.test_vpc.id}"
  #availability_zone = "ap-south-1a"

 # }  

  resource "aws_security_group" "group2" {
  vpc_id = "${aws_vpc.test_vpc.id}"
}


resource "aws_security_group_rule" "db_server_ingress_ssh" {
    from_port         = 22
    protocol          = "tcp"
    security_group_id = "${aws_security_group.group2.id}"
    to_port           = 22
    type              = "ingress"
    cidr_blocks       = ["${var.all_ip}"]
    }

resource "aws_security_group_rule" "mysql_port_ingress" {
        from_port         = 3306
        protocol          = "tcp"
        security_group_id = "${aws_security_group.group2.id}"
        to_port           = 3306
        type              = "ingress"
        cidr_blocks       = ["${aws_instance.app1.private_ip}/32"]
        }



resource "aws_eip" "db_eip" {
  instance = "${aws_instance.database.id}"
  }