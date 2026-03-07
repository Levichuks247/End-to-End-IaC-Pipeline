provider "aws" {
  region = "eu-west-2"
}

# 1. IAM Role (Kept from your original)
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

resource "aws_iam_role_policy_attachment" "eb_web" {
  role       = aws_iam_role.eb_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier"
}

resource "aws_iam_instance_profile" "eb_profile" {
  name = "devops-lab-eb-profile"
  role = aws_iam_role.eb_role.name
}

# 2. Deployment Storage (NEW: This holds your Dockerrun.aws.json file)
resource "random_id" "bucket_id" {
  byte_length = 4
}

resource "aws_s3_bucket" "deploy_bucket" {
  bucket = "levichuks-deploy-bucket-${random_id.bucket_id.hex}"
}

resource "aws_s3_object" "deploy_file" {
  bucket = aws_s3_bucket.deploy_bucket.id
  key    = "Dockerrun.aws.json"
  source = "Dockerrun.aws.json" # This pulls the file from your folder
}

# 3. Application Version (NEW: This tells AWS "This is Version 1 of my app")
resource "aws_elastic_beanstalk_application_version" "latest" {
  name        = "v1-${timestamp()}"
  application = aws_elastic_beanstalk_application.app.name
  description = "Initial deployment of Python Docker App"
  bucket      = aws_s3_bucket.deploy_bucket.id
  key         = aws_s3_object.deploy_file.id
}

# 4. Elastic Beanstalk Application
resource "aws_elastic_beanstalk_application" "app" {
  name = "devops-interview-app"
}

# 5. The Environment (London Region)
resource "aws_elastic_beanstalk_environment" "env" {
  name                = "devops-app-env"
  application         = aws_elastic_beanstalk_application.app.name
  solution_stack_name = "64bit Amazon Linux 2023 v4.10.0 running Docker"
  
  # NEW: Link the server to the specific code version we just created
  version_label = aws_elastic_beanstalk_application_version.latest.name

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.eb_profile.name
  }
}

output "app_url" {
  value = aws_elastic_beanstalk_environment.env.endpoint_url
}