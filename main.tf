provider "aws" {
  region = "eu-west-2"
}

# 1. IAM Permissions (Version 3)
resource "aws_iam_role" "eb_role" {
  name = "devops-lab-eb-role-v3" # Changed to v3
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
  name = "devops-lab-eb-profile-v3" # Changed to v3
  role = aws_iam_role.eb_role.name
}

# 2. Deployment Storage (S3)
resource "random_id" "bucket_id" {
  byte_length = 4
}

resource "aws_s3_bucket" "deploy_bucket" {
  bucket = "levichuks-deploy-bucket-${random_id.bucket_id.hex}"
}

resource "aws_s3_object" "deploy_file" {
  bucket = aws_s3_bucket.deploy_bucket.id
  key    = "Dockerrun.aws.json"
  source = "Dockerrun.aws.json"
}

# 3. Elastic Beanstalk Application (Version 3)
resource "aws_elastic_beanstalk_application" "app" {
  name = "devops-interview-app-v3" # Changed to v3
}

# 4. Application Version
resource "aws_elastic_beanstalk_application_version" "latest" {
  depends_on  = [aws_s3_object.deploy_file] 
  name        = "v1-${timestamp()}"
  application = aws_elastic_beanstalk_application.app.name
  description = "Initial deployment of Nodejs Docker App"
  bucket      = aws_s3_bucket.deploy_bucket.id
  key         = aws_s3_object.deploy_file.key
}

# 5. The Infrastructure (Version 3)
resource "aws_elastic_beanstalk_environment" "env" {
  name                = "devops-app-env-v3" # Changed to v3
  application         = aws_elastic_beanstalk_application.app.name
  solution_stack_name = "64bit Amazon Linux 2023 v4.10.0 running Docker"
  version_label       = aws_elastic_beanstalk_application_version.latest.name

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.eb_profile.name
  }
}

output "app_url" {
  value = aws_elastic_beanstalk_environment.env.endpoint_url
}