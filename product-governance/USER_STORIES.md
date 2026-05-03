# 📋 Project Governance: Enterprise-Grade IaC Pipeline
**Strategic Management Framework for B2B SaaS Infrastructure**

---

## 📝 Project Brief
* **Project Name:** Enterprise B2B SaaS Infrastructure Foundation
* **Role:** Technical Product Owner (TPO) / Lead Infrastructure Engineer
* **Status:** Production-Ready (2026 Standards)

### 🎯 Objective
To engineer and implement a secure, compliant, and automated **"Single-Command"** environment for a high-availability Node.js application, shifting the organization from manual **"Click-Ops"** to scalable **"GitOps."**

### 💼 Business Context
A rapidly growing SaaS startup required a transition to automated infrastructure to meet **DORA** and **GDPR** security audit requirements while minimizing **Environment Parity** risks.

---

## 🚦 Definition of Ready (DoR)
*Before engineering began, these criteria had to be met to ensure project success:*
1.  **Architecture Blueprint:** A high-level diagram of the **VPC** and Subnet layout must be approved.
2.  **Environment Access:** **AWS IAM** credentials with appropriate permissions must be secured.
3.  **Tooling Parity:** Terraform (v1.x+) and Docker must be installed and verified in the local dev environment.
4.  **Baseline Code:** The Node.js application source code must be functional and ready for containerization.

---

## 🎯 User Stories & Acceptance Criteria (AC)

### US.1: Automated Developer Experience (DX)
**As a** Lead Developer,
**I want** a standardized Node.js + PostgreSQL environment provisioned via Terraform,
**So that** I can eliminate manual configuration mistakes and accelerate "Time-to-Market."

* **AC 1:** Infrastructure must be provisioned via a single `terraform apply`.
* **AC 2:** The application must be accessible via a public **Load Balancer** URL immediately after provisioning.
* **AC 3:** Code must pass `terraform validate` and `terraform fmt` for linting and integrity.

### US.2: Data Sovereignty & Security (GDPR/DORA)
**As a** Compliance Officer,
**I want** the database instance secured within a private subnet,
**So that** we satisfy EU data residency and 2026 security audit standards.

* **AC 1:** The **RDS** instance must be set to `publicly_accessible = false`.
* **AC 2:** Database placement must be restricted to a **Private Subnet** with no direct route to the Internet Gateway.
* **AC 3:** Security Groups must implement **Least Privilege**, only permitting ingress on port `5432` from the App-Tier.

### US.3: FinOps & Cost Attribution
**As a** Product Manager,
**I want** every resource automatically injected with administrative tags,
**So that** I can maintain 100% budget transparency for our B2B client tiers.

* **AC 1:** The Terraform provider must utilize `default_tags` for universal coverage.
* **AC 2:** Mandatory tags must include: `Project`, `Environment`, `CostCenter`, and `Compliance`.
* **AC 3:** All resources must be filterable within the AWS Billing Dashboard for granular cost analysis.

### US.4: System Resilience & Self-Healing
**As a** Customer Success Manager,
**I want** the application to gracefully handle infrastructure startup delays,
**So that** users experience zero-downtime during platform "cold starts."

* **AC 1:** `app.js` must implement an **Asynchronous Retry Loop** for database connectivity.
* **AC 2:** The application must expose a `/health` endpoint for the Load Balancer to monitor.
* **AC 3:** The AWS environment must only signal a "Healthy/Green" status after receiving a `200 OK` from the app layer.

---

## 🏆 Definition of Done (DoD)
1.  **State Governance:** Terraform state is locked in a **Remote S3 Backend**.
2.  **Containerization:** Application is containerized via **Docker** and successfully deployed.
3.  **Verification:** All 4 User Stories have met their **Acceptance Criteria**.
4.  **Teardown Integrity:** Infrastructure is destroyed cleanly via `terraform destroy` to confirm no "orphaned" resources remain.

---

## 📖 Glossary of Terms
* **AC (Acceptance Criteria):** The specific requirements that must be met for a User Story to be considered complete.
* **AWS (Amazon Web Services):** The cloud computing platform used to host the infrastructure.
* **DoD (Definition of Done):** A checklist of requirements that must be met before a project or task is officially finished.
* **DoR (Definition of Ready):** The set of conditions that must be met before work can begin on a project or task.
* **DORA (Digital Operational Resilience Act):** A 2026 EU regulation focused on the ability of financial and tech entities to withstand and recover from IT-related disruptions.
* **GDPR (General Data Protection Regulation):** A rigorous EU data privacy and security law.
* **GitOps:** A practice where infrastructure is managed using version control (like Git) as the "Source of Truth."
* **IaC (Infrastructure as Code):** The process of managing and provisioning computer data centers through machine-readable definition files (like Terraform).
* **IAM (Identity and Access Management):** A framework of policies and technologies to ensure that the right users have the appropriate access to technology resources.
* **RDS (Relational Database Service):** A managed database service provided by AWS.
* **VPC (Virtual Private Cloud):** A private, isolated section of the AWS cloud where you can launch resources in a virtual network.
