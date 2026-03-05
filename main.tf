provider "aws" {
  region = "eu-west-2"
}

# 1. Create the IAM Role for the EC2 Instance
resource "aws_iam_role" "eb_role" {
  name = "devops-lab-eb-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })
}

# 2. Attach policies so Docker can run
resource "aws_iam_role_policy_attachment" "eb_web" {
  role       = aws_iam_role.eb_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier"
}

resource "aws_iam_instance_profile" "eb_profile" {
  name = "devops-lab-eb-profile"
  role = aws_iam_role.eb_role.name
}

# 3. Create the Elastic Beanstalk Application
resource "aws_elastic_beanstalk_application" "app" {
  name = "devops-interview-app"
}

# 4. Create the Environment (London Region)
resource "aws_elastic_beanstalk_environment" "env" {
  name                = "devops-app-env"
  application         = aws_elastic_beanstalk_application.app.name
  # Using the latest Amazon Linux 2023 stack
  solution_stack_name = "64bit Amazon Linux 2023 v4.10.0 running Docker"

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.eb_profile.name
  }
}

output "app_url" {
  value = aws_elastic_beanstalk_environment.env.endpoint_url
}
