# IAM ROLES
resource "aws_iam_role" "eb_role" {
  name = "devops-lab-eb-role-v11"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
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

# STORAGE & DEPLOYMENT
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
  name        = "v1-${timestamp()}"
  application = aws_elastic_beanstalk_application.app.name
  bucket      = aws_s3_bucket.deploy_bucket.id
  key         = aws_s3_object.deploy_file.key
}

# ENVIRONMENT
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
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "InstanceType"
    value     = var.instance_type
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
    value     = var.db_password
  }
}

output "app_url" {
  value = aws_elastic_beanstalk_environment.env.endpoint_url
}