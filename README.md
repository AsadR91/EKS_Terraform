# EKS_Terraform

Improvements:
* Centralized names/tags using locals

* Parameterized region, AZs, instance type, and scaling settings

* Removed duplicated subnet/resource blocks using count

* Used jsonencode for assume role policies to avoid messy HEREDOCs

* Renamed resources for consistency (main, node, eks, etc.)
