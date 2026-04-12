resource "aws_db_subnet_group" "db_sub" {
  name       = "main-db-sub-v12" # Changed from v11 to v12
  subnet_ids = [aws_subnet.public.id, aws_subnet.secondary.id]
  
  tags = {
    Name = "Enterprise-DB-Subnet-Group"
  }
}

resource "aws_db_instance" "postgres" {
  identifier             = "devops-db-v11"
  allocated_storage      = 20
  engine                 = "postgres"
  instance_class         = "db.t4g.micro"
  db_name                = "myappdb"
  username               = "postgres"
  password               = var.db_password # Using variable for security
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.db_sub.name
  publicly_accessible    = false
}