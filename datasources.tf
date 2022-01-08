# datasource to obtain routetable id
data "aws_route_tables" "rts" {
  vpc_id     = aws_vpc.vpc_one.id
  depends_on = [aws_subnet.db_subnet_1, aws_subnet.db_subnet_2]
  filter {
    name   = "vpc-id"
    values = [aws_vpc.vpc_one.id]
  }
}

# random password generator for database
resource "random_password" "password" {
  count   = 1
  length  = 16
  special = true
}
