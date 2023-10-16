# Create an RDS instance
resource "aws_db_instance" "rds_instance" {
  allocated_storage    = 20
  engine               = "postgres"
  engine_version       = "13.7"
  instance_class       = "db.t3.micro"
  db_name              = "railsdb"
  username             = "dbuser"
  password             = var.db_password
  parameter_group_name = "default.postgres13"
  skip_final_snapshot  = true

  vpc_security_group_ids = [aws_security_group.rds_security_group.id]
  db_subnet_group_name     = aws_db_subnet_group.rails_db_subnet_group.name
}

# Define a DB subnet group
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rails-db-subnet-group"
  subnet_ids = aws_subnet.private_subnets[*].id
}

resource "aws_security_group" "rds_security_group" {
  vpc_id = aws_vpc.main_vpc.id  
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}