# create a db subnet group spanning 2 subnets
resource "aws_db_subnet_group" "database" {
  depends_on = [aws_route_table_association.db_subnet_1, aws_route_table_association.db_subnet_2]
  subnet_ids = [aws_subnet.db_subnet_1.id, aws_subnet.db_subnet_2.id]
  name       = "dbsubnetgroup"
  tags = {
    Name = "My DB subnet group"
  }
}

# allow ingress for port 3306 from vpc and egress to on all ports to all hosts
resource "aws_security_group" "allow_db_traffic" {
  depends_on  = [aws_db_subnet_group.database]
  name        = "allow_db_traffic"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.vpc_one.id

  ingress {
    description = "Database"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["${aws_vpc.vpc_one.cidr_block}"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

# creation of the actual database instance itself
resource "aws_db_instance" "database" {
  depends_on           = [aws_security_group.allow_db_traffic]
  allocated_storage    = 10
  engine               = "postgres"
  engine_version       = "13"
  instance_class       = "db.t3.micro"
  name                 = "databaseone"
  username             = "master"
  password             = random_password.password[0].result
  db_subnet_group_name = aws_db_subnet_group.database.name
  port                 = 3306
  skip_final_snapshot  = true
}
