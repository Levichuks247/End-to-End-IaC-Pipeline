🚀 End-to-End IaC Pipeline
A Production-Ready Node.js & PostgreSQL Deployment on AWS

📌 Project Overvie
This project demonstrates a fully automated, containerized deployment of a web application. Using Infrastructure as Code (IaC), I built a secure cloud environment connecting a Node.js web server to a managed PostgreSQL database.

The goal was to move away from manual configuration and create a repeatable, self-healing system that follows DevOps best practices.

🛠 Tech Stack & Tool
Infrastructure: Terraform (IaC)
Cloud Provider: AWS (VPC, RDS, Elastic Beanstalk, S3, IAM, EC2)
Containerization: Docker
App/DB: Node.js (Express) & PostgreSQL
Version Control: GitHub & Git
CLI Tools: AWS CLI, Terraform CLI, Zip

🏗 Project Progress & Milestone

Day 1: Foundation & Automation
Dockerization: Created a Dockerfile to package the Node.js application, ensuring environment parity between local development and AWS.
Terraform Architecture: Wrote the initial IaC scripts to provide a custom VPC, Public/Secondary Subnets, and an Internet Gateway.
Remote State Management (S3 Backend): Implemented the "DevOps Gold Standard" by moving the Terraform state file to an AWS S3 Bucket. This ensures state persistence, enables collaboration, and prevents resource duplication.
CI/CD Foundation: Configured the deployment flow using GitHub Actions and shell scripts to package the application as a deploy.zip for AWS Elastic Beanstalk.

Day 2: Database Integration & Resilience
Managed Persistence (RDS): Deployed a PostgreSQL instance via Amazon RDS. I isolated the database in a private subnet group so it is not accessible from the public internet.
Security Group Nesting: Implemented to "Least Privilege" security model. The Database Security Group was configured to only accept traffic on port 5432 if it originates from the Web Tier's Security Group.
The "Retry Logic" Solution: Solved a critical "Race Condition" where the app would crash because the DB took longer to boot than the server. I developed an Asynchronous Retry Loop in app.js using async/await to poll for a connection until the DB is ready.

Day 3: Troubleshooting & State Reconciliation
Handling Infrastructure Deadlocks: Resolved complex "Dependency Violations" where AWS refused to delete Security Groups due to active Network Interfaces (ENIs).
Terraform State Management: Mastered advanced commands like terraform state rm and terraform refresh to decouple stuck resources and fix "State Drift" between the local environment and the AWS Cloud.
Resource Versioning: Implemented a versioned deployment strategy (moving from v5/v10 to v11) to ensure a clean, conflict-free environment for new updates.

⚠️ Key Engineering Challenges
The "Unexpected Exit" Error: Fixed a common Elastic Beanstalk issue where Docker containers crash on startup by refining the port mapping (Port 80 to Port 3000) and database connection strings.
ENI Dependency Loops: Managed the teardown of RDS instances that "held" onto" network cables, preventing Terraform from finishing its cleanup. Solved by improving resource dependency mapping in HCL.

🚀 How to Run
Initialize: terraform init (Connects to the S3 Remote Backend)
Bundle: zip deploy.zip app.js package.json Dockerfile Dockerrun.aws.json
Deploy: terraform apply -auto-approve
Teardown: terraform destroy -auto-approve

🏆 Final Result
The infrastructure is designed to be fully automated and cost-efficient. By using Terraform, the entire production environment can be stood up or torn down with a single command.