terraform {
  backend "s3" {
    bucket = "acs730-project1-vpc-peering-abi" // Bucket where to SAVE Terraform State
    key    = "VPC-Peering/terraform.tfstate"   // Object name in the bucket to SAVE Terraform State
    region = "us-east-1"                       // Region where bucket is created
  }
}