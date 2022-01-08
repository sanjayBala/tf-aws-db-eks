# create a vpc in which the database will reside
resource "aws_vpc" "vpc_one" {
  cidr_block = "10.0.0.0/24"
}

# create 2 subnets for database subnet group to be spread across
# each subnet needs to be across different AZs
resource "aws_subnet" "db_subnet_1" {
  depends_on        = [aws_vpc.vpc_one]
  vpc_id            = aws_vpc.vpc_one.id
  availability_zone = "us-east-1a"
  cidr_block        = "10.0.0.0/25"
  tags = {
    Name = "db_subnet"
  }
}

resource "aws_subnet" "db_subnet_2" {
  depends_on        = [aws_vpc.vpc_one]
  vpc_id            = aws_vpc.vpc_one.id
  availability_zone = "us-east-1b"
  cidr_block        = "10.0.0.128/25"
  tags = {
    Name = "db_subnet"
  }
}

# associate route table with db subnets
resource "aws_route_table_association" "db_subnet_1" {
  depends_on     = [aws_subnet.db_subnet_1]
  subnet_id      = aws_subnet.db_subnet_1.id
  route_table_id = tolist(data.aws_route_tables.rts.ids)[0]
}

resource "aws_route_table_association" "db_subnet_2" {
  depends_on     = [aws_subnet.db_subnet_2]
  subnet_id      = aws_subnet.db_subnet_2.id
  route_table_id = tolist(data.aws_route_tables.rts.ids)[0]
}
