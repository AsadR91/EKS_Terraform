# 🚀 AWS EKS Cluster with Terraform

This Terraform configuration sets up a complete **Elastic Kubernetes Service (EKS)** cluster in AWS, along with networking, security, and IAM resources.

---

## 📦 What It Deploys

- A **VPC** with public subnets in multiple availability zones
- An **Internet Gateway** and **Route Table** for public access
- **Security Groups** for the EKS cluster and nodes
- An **EKS Cluster** (control plane)
- An **EKS Node Group** (EC2 worker nodes)
- Required **IAM Roles and Policies**
- Outputs for key resource IDs

---

## 🧠 How It Works

> Think of this like building a secure, ready-to-use home for running your container apps in the cloud.

1. **VPC & Subnets:**  
   Your private network is created with two subnets in different availability zones.

2. **Internet Access:**  
   An Internet Gateway and Route Table give your subnets access to the internet.

3. **Security Groups:**  
   Think of these as door policies for your network—controlling what can get in or out.

4. **EKS Cluster:**  
   This is the "brain" of Kubernetes—managing deployments and workloads.

5. **Node Group:**  
   These are EC2 servers (workers) that actually run your containers.

6. **IAM Roles & Policies:**  
   Grants permissions so AWS knows what actions each component is allowed to perform.

7. **Outputs:**  
   Easily fetch key values like the cluster ID or subnet IDs after deployment.

---

## 🛠️ How to Use

### 1. Prerequisites

- [Terraform](https://www.terraform.io/downloads.html)
- An AWS account with CLI configured (`aws configure`)
- An existing EC2 key pair in your region

---

### 2. Clone the Repo

```bash
git clone https://github.com/your-username/terraform-eks-cluster.git
cd terraform-eks-cluster
```
### 3. Customize Variables (Optional)
Edit variables.tf to tweak region, instance size, or number of subnets.

Example:
```bash
variable "region" {
  default = "us-east-1"
}

variable "node_instance_type" {
  default = "t2.medium"
}
```

### 4. Initialize and Apply
```bash
terraform init
terraform apply
```


**Note** Confirm when prompted. The process takes a few minutes.

### 5. Outputs
After it's done, Terraform will show you values like:

- EKS Cluster ID

- Node Group ID

- VPC ID

- Subnet IDs

### 🧹 Cleanup
To destroy all resources:
```bash
terraform destroy
```

### 📄 Files Overview

| File           | Description                                |
| -------------- | ------------------------------------------ |
| `main.tf`      | All core resources: VPC, EKS, IAM, subnets |
| `variables.tf` | Configurable input variables               |
| `output.tf`    | Outputs of key resources                   |
| `README.md`    | This documentation                         |

🧠 Why DRY Code?
We’ve reduced repetition using:

- Locals for consistent naming

- Variables for configurable values

- Count and for_each where needed

- jsonencode for clean IAM policy blocks

#### This keeps your infrastructure:

- Easy to maintain

- Reusable for future projects

- Less prone to human error


#### 📬 Feedback or Questions?
Feel free to open an issue or PR with suggestions!
