terraform {
  backend "s3" {
    bucket         = "levichuks-terraform-state-v11"
    key            = "terraform.tfstate"
    region         = "eu-west-2" 
    encrypt        = true
  }
}

provider "aws" {
  region = "eu-west-2"
}

# 1. NETWORKING
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = { Name = "devops-interview-vpc" }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "eu-west-2a"
}

resource "aws_subnet" "secondary" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "eu-west-2b"
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# 2. SECURITY GROUPS
resource "aws_security_group" "eb_sg" {
  name         = "database-sg-v11" # ERROR: DUPLICATE NAME TRIGGER
  vpc_id       = aws_vpc.main.id
  description  = "Allow HTTP inbound"

  ingress {
    from_port   = 80
    to_port     = 80
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

resource "aws_security_group" "db_sg" {
  name         = "database-sg-v11"
  vpc_id       = aws_vpc.main.id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.eb_sg.id]
  }
}

# 3. DATABASE
resource "aws_db_subnet_group" "db_sub" {
  name       = "main-db-sub-v11"
  subnet_ids = [aws_subnet.public.id, aws_subnet.secondary.id]
}

resource "aws_db_instance" "postgres" {
  identifier           = "devops-db-v11"
  allocated_storage    = 20
  engine               = "postgres"
  instance_class       = "db.t4g.micro"
  db_name              = "myappdb"
  username             = "postgres"
  password             = "SecurePass123!"
  skip_final_snapshot  = true
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  db_subnet_group_name = aws_db_subnet_group.db_sub.name
  publicly_accessible  = false
}

# 4. IAM & BEANSTALK
resource "aws_iam_role" "eb_role" {
  name = "devops-lab-eb-role-v11"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "eb_web" {
  role       = aws_iam_role.eb_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier"
}

resource "aws_iam_instance_profile" "eb_profile" {
  name = "devops-lab-eb-profile-v11"
  role = aws_iam_role.eb_role.name
}

resource "aws_s3_bucket" "deploy_bucket" {
  bucket_prefix = "levichuks-deploy-"
}

resource "aws_s3_object" "deploy_file" {
  bucket = aws_s3_bucket.deploy_bucket.id
  key    = "deploy.zip"
  source = "deploy.zip"
}

resource "aws_elastic_beanstalk_application" "app" {
  name = "devops-interview-app-v11"
}

resource "aws_elastic_beanstalk_application_version" "latest" {
  name         = "v1-${timestamp()}"
  application = aws_elastic_beanstalk_application.app.name
  bucket      = aws_s3_bucket.deploy_bucket.id
  key         = aws_s3_object.deploy_file.key
}

resource "aws_elastic_beanstalk_environment" "env" {
  name                = "devops-app-env-v11"
  application         = aws_elastic_beanstalk_application.app.name
  solution_stack_name = "64bit Amazon Linux 2023 v4.10.0 running Docker"
  version_label       = aws_elastic_beanstalk_application_version.latest.name

  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = aws_vpc.main.id
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = aws_subnet.public.id
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "SecurityGroups"
    value     = aws_security_group.eb_sg.id
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.eb_profile.name
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "DB_HOSTNAME"
    value     = aws_db_instance.postgres.address
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "DB_NAME"
    value     = aws_db_instance.postgres.db_name
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "DB_USER"
    value     = aws_db_instance.postgres.username
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "DB_PASSWORD"
    value     = aws_db_instance.postgres.password
  }
}

output "app_url" {
  value = aws_elastic_beanstalk_environment.env.endpoint_url
}