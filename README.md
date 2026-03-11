# 🚀 End-to-End IaC Pipeline
### *A Production-Ready Node.js & PostgreSQL Deployment on AWS*

---

## 📌 Project Overview
**The Problem:** Manual deployments often lead to "Configuration Drift," security vulnerabilities, and deployment failures due to environment mismatches.

**The Solution:** This project provides a fully automated **Production Environment** using Infrastructure as Code (IaC). It handles the entire lifecycle—from networking (VPC) and secure data persistence (RDS) to automated CI/CD. It is a "Single-Command" infrastructure that is secure, scalable, and self-healing.



## 🛠 Tech Stack & Tools
| Category | Tools |
| :--- | :--- |
| **Infrastructure** | Terraform (IaC) |
| **Cloud Provider** | AWS (VPC, RDS, Beanstalk, S3, IAM) |
| **Containerization** | Docker |
| **App & Database** | Node.js (Express) & PostgreSQL |
| **CI/CD** | GitHub Actions |
| **State Storage** | AWS S3 (Remote Backend) |

---

## 🏗 Key Solutions & Engineering Milestones

### **The "Retry Logic" Solution (Solving Race Conditions)**
In cloud environments, the application often starts faster than the database, causing immediate crashes.
* **Implementation:** Developed an **Asynchronous Retry Loop** in `app.js` using `async/await`.
* **Result:** The app "polls" the database until it's ready, ensuring 100% startup reliability without manual intervention.

### **Secure Data Isolation**
* **Private Subnets:** Isolated the RDS instance from the public internet.
* **Security Group Nesting:** Implemented a "Least Privilege" model where the DB *only* accepts traffic from the Web-Tier's specific Security Group ID.

---

## 📅 Roadmap: The Build Journey

### **Day 1: Automation Foundation**
* **Remote State:** Implemented the "DevOps Gold Standard" by moving Terraform state to **AWS S3**.
* **Dockerization:** Packaged the Node.js app to ensure parity between local and cloud environments.

### **Day 2: Persistence & Security**
* **RDS Deployment:** Provisioned a managed PostgreSQL instance with automated backups.
* **Network Security:** Resolved "Dependency Violations" and managed **Elastic Network Interfaces (ENIs)** during teardown.

### **Day 3: CI/CD & Maintenance**
* **Node.js 24 Migration:** Upgraded GitHub Actions to `v4/v3` to future-proof the pipeline against 2026 deprecations.
* **State Reconciliation:** Mastered `terraform state rm` and `refresh` to fix state drift.

---

## 🚀 How to Run
1.  **Initialize:** `terraform init` 
2.  **Package:** `zip deploy.zip app.js package.json Dockerfile Dockerrun.aws.json`
3.  **Deploy:** `terraform apply -auto-approve`
4.  **Teardown:** `terraform destroy -auto-approve`

---

## 🏆 Business Impact
This architecture reduces deployment time from hours to minutes, eliminates human error in configuration, and ensures the database is protected from public security threats.