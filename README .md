         ___        ______     ____ _                 _  ___
        / \ \      / / ___|   / ___| | ___  _   _  __| |/ _ \
       / _ \ \ /\ / /\___ \  | |   | |/ _ \| | | |/ _` | (_) |
      / ___ \ V  V /  ___) | | |___| | (_) | |_| | (_| |\__, |
     /_/   \_\_/\_/  |____/   \____|_|\___/ \__,_|\__,_|  /_/

---

# Deploy Multi-Environment Infrastructure using Terraform

This project sets up AWS infrastructure for Prod and Non-Prod environments using Terraform modules for efficient management.

Project Structure

- Prod: Production environment .
- Non-Prod: Non Production environment .
- Peering: VPC peering configurations.
-
- modules:
  - `aws_peering`: Manages VPC peering.
  - `aws_network`: Configures VPC, subnets, routetables, NAT Gateways, Internet Gateways
  - `globalvars`: Shared variables.

VPC nonprod:

- 2 private and 2 public subnets.
- Bastion host and NAT gateway deployed in the public subnets.
- VM1 and VM2 deployed in private subnets with Apache web servers.

VPC prod:

- 2 private subnets with no public subnets.
- VM1 and VM2 deployed in private subnets.

Peering:

- VPC prod and VPC nonprod connected via a peering connection.
- Appropriate route tables configured and associated with subnets for traffic routing.
- SSH and HTTP ports open to allow connectivity between resources.

Access & Connectivity:

- Admins can connect to the bastion host via SSH using `ec2-user`.
- From the bastion host, admins can SSH into all 4 VMs across the prod and nonprod VPCs.
- Admins can send HTTP requests to the Apache web servers on VM1 and VM2 in the nonprod VPC.

Prerequisites

1. AWS Cloud9: Launch an AWS Cloud9 environment.
2. Git: Ensure Git is installed.
3. Create Bucket from AWS Dashboard for both Prod and Non Prod to strore the terraform states which we will use later on to retrieve values.
   (For my case I have also created one bucket for VPC Peering.) \***\*Later use the respective buckets in their respective config.tf file, as config file should be present in respective directories; Non- Prod/network/config.tf, Prod/network/config.tf, Non-Prod/webservers/config.tf, Prod/webservers/config.tf and Peering/config.tf.\*\***

   With the help of terraform.tfstate that are present inside the network and webservers directories inside the Prod and Non-Prod buckets, we can retrieve necessary values required for the configuration.

   S3-Buckets example = acs730-project-nonprod-abi for non prod. Inside this bucket 2 different directories will be created for network and webservers part.

Setting Up on AWS Cloud9

1.  Clone the Repo:
    git clone https://github.com/AbiChitrakar/Deploy-Multi-Environment-Infrastructure-using-Terraform.git
    cd Deploy-Multi-Environment-Infrastructure-using-Terraform

2.  Generate SSH Key Pair:

    - Use `ssh-keygen` to generate a new SSH key pair and store it in the `~/.ssh/` directory with the name `aws_ec2_key`:
      ssh-keygen -t rsa -b 2048 -f ~/.ssh/aws_ec2_key ""
    - Set appropriate permissions for the key to make it secure:
      chmod 400 ~/.ssh/aws_ec2_key

    - This key will be used later for connecting to the EC2 instances (VMs).

3.  Install Terraform:
    sudo yum install -y yum-utils
    sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
    sudo yum install -y terraform

4.  Navigate to the Non-Prod network directory and set an alias for Terraform:
    cd Non-Prod/network
    alias tf=terraform

5.  Initialize Terraform:
    tf init

6.  Run Terraform Commands:
    tf fmt

    - Validate the configuration:
      tf validate

    -Plan the deployment using the `nonprod.tfvars` file:

        tf plan -var-file='../nonprod.tfvars'

    - Apply the configuration:

      tf apply -var-file='../nonprod.tfvars'

7.  After successful deployment of Non-Prod network, move to the Prod network directory and repeat the same steps:

    - Navigate to the Prod network directory:
      cd ../../Prod/network

    - Set an alias for Terraform:

      alias tf=terraform

    - Initialize Terraform in this directory:
      tf init

    - Format the configuration:
      tf fmt

    - Validate the configuration:
      tf validate

    - Plan the deployment using the `prod.tfvars` file:
      tf plan -var-file='../prod.tfvars'

    - Apply the configuration:
      tf apply -var-file='../prod.tfvars'

8.  After successful deployment of Prod network, move to the Peering directory and run Terraform directly (no `.tfvars` files):

    - Navigate to the Peering directory:

      cd ../../Peering

    - Set an alias for Terraform:
      alias tf=terraform

    - Initialize Terraform in this directory:
      tf init

    - Format the configuration:
      tf fmt

    - Validate the configuration:
      tf validate

    - Plan the deployment:
      tf plan

    - Apply the configuration:
      tf apply

Configuration Details:

- VPC Peering: VPC peering has been set up between the Prod and Non-Prod VPCs to allow communication between resources in both environments.
- Route Tables: Custom route tables have been created and associated with the respective subnets to ensure traffic flows correctly between the VPCs.
- Security Groups: Security groups for the bastion host and VMs allow SSH access (port 22) and HTTP access (port 80) for the Apache web servers.
- SSH & HTTP Access:
  - Admins can connect to the bastion host using SSH.
  - From the bastion host, admins can SSH into all VMs (VM1 and VM2 in both Prod and Non-Prod VPCs).
  - Admins can send HTTP requests to the Apache web servers running on VM1 and VM2 in the Non-Prod VPC.

---

Setting Up VMs in Nonprod/Webservers

1. Navigate to the Nonprod/Webservers directory:
   cd Non-Prod/Webservers

2. Set an alias for Terraform:
   alias tf=terraform

3. Initialize Terraform:

   Initialize the Terraform configuration for this directory:
   tf init

4. Format Terraform Configuration:

   Format the configuration files to ensure proper formatting:
   tf fmt

5. Validate the Configuration:

   Validate the configuration to check for any errors or issues:
   tf validate

6. Plan the Deployment:

   Plan the deployment, using the `nonprod.tfvars` file for environment-specific variable values:
   tf plan -var-file='../nonprod.tfvars'

7. Apply the Configuration:

   Apply the configuration to provision the web servers and other resources in the Non-Prod VPC:
   tf apply -var-file='../nonprod.tfvars'

### After Applying:

- The Bastion VM will be provisioned in the Non-Prod VPC in Public SUbnet 2, allowing secure access to other VMs and services.
- The web servers (VM1 and VM2) in the Non-Prod VPC in the Private Subnets will be provisioned with Apache web servers running on them.
- These instances will serve HTTP requests on port 80 and allow SSH access on port 22 for administration.
- These ports are only available for the specific private ip of BAstion Host so as to make more secure.

### Setting Up VMs in Prod/Webservers

1. Navigate to the Prod/Webservers directory:
   cd Prod/Webservers

2. Set an alias for Terraform:
   alias tf=terraform

3. Initialize Terraform:
   Initialize the Terraform configuration for this directory:
   tf init

4. Format Terraform Configuration:

   Format the configuration files to ensure proper formatting:
   tf fmt

5. Validate the Configuration:

   Validate the configuration to check for any errors or issues:
   tf validate

6. Plan the Deployment:

   Plan the deployment, using the `prod.tfvars` file for environment-specific variable values:
   tf plan -var-file='../prod.tfvars'

7. Apply the Configuration:

   Apply the configuration to provision the web servers and other resources in the Prod VPC:
   tf apply -var-file='../prod.tfvars'

---

### After Applying:

- The VMs (VM1 and VM2) in the Prod VPC will be provisioned, but **only SSH access (port 22)** will be allowed, restricted to the **Bastion host's IP** for administration.
- These VMs will not have HTTP access on port 80.
- Admins can SSH into the VMs from the Bastion host, but external access to port 80 is not available in this environment.

Visibility of IPs
Private IPs of VMs:

- The private IPs of the VMs (VM1 and VM2) in both Prod and Non-Prod VPCs are provisioned in the respective private subnets.
- These private IPs are internal to each VPC and are used for communication within their own VPC.
- Admins can SSH into these private VMs (VM1 and VM2 in both Prod and Non-Prod) through the Bastion host, which has access to the private subnets via its private IP.

### Bastion Host IPs:

- The Bastion hos\* is deployed in a public subnet(in Non-Prod environment).
- **Private IP**: Visible within the Bastion host's VPC (either Prod or Non-Prod), used for internal communications between the Bastion host and the private VMs (VM1 and VM2).
- **Public IP**: The Bastion host is assigned a public IP (in **Non-Prod**) for SSH access from outside the VPC. This is the IP that admins use to SSH into the Bastion host from an external machine (e.g., Cloud9, local machine, etc.).

### SSH Access:

1. SSH to Bastion Host:

   - Admins can SSH into the Bastion host using its public IP (port 22). The Bastion host is the only resource accessible from outside the VPC.

2. SSH from Bastion Host to VMs:

   - Once connected to the Bastion host, admins can SSH into the private VMs (VM1 and VM2) in both **Prod** and **Non-Prod** environments using their **private IPs**.
   - The Bastion host acts as a gateway to access the private VMs, as these VMs do not have direct external access.

3. No Direct External Access:
   - There is no direct external access to the private VMs. The Bastion host is the only instance that has direct access to the private subnets and VMs.

## Steps to Copy Private Key from Local Machine to Bastion Host and VMs

### Step 1: Copy the Private Key from Local Machine to Bastion Host

From your **local machine**, run the following command to copy your SSH private key to the Bastion host:

scp -i ~/.ssh/aws_ec2_key ~/.ssh/aws_ec2_key ec2-user@'Bastion-Public-IP':/home/ec2-user/

Replace 'Bastion-Public-IP' with the public IP of the Bastion host.
This command copies the aws_ec2_key from your local machine to the /home/ec2-user/ directory on the Bastion host.

Step 2: SSH into the Bastion Host
SSH into the Bastion host using its private IP:
ssh -i ~/.ssh/aws_ec2_key ec2-user@'Bastion-Public-IP'
Replace 'Bastion-Public-IP' with the private IP of the Bastion host.
This allows you to access the Bastion host and then use it to SSH into private VMs.

Step 3: SSH into Each Private VM from the Bastion Host
Once you are logged into the Bastion host, you can SSH into the private VMs in both the Prod and Non-Prod environments directly using the copied private key from local to bastion . Use the following command:

ssh -i /home/ec2-user/aws_ec2_key ec2-user@'VM-Private-IP'
Replace 'VM-Private-IP' with the private IP of the VM you want to access.
This allows you to securely SSH into the VMs from the Bastion host without needing to copy the key to the VMs manually.
Repeat this for each VM in both environments. For example:
ssh -i /home/ec2-user/aws_ec2_key ec2-user@10.0.1.10 # VM1 in Non-Prod

#### Curl the Web Server from Bastion Host (Non-Prod)

After logging into the Bastion host, you can curl the private IPs of VM1 and VM2 in the Non-Prod environment to test the web server. This will show the welcome screen with the private IP and text defined in the user data script.

Run the following command for VM1:
curl http://'VM1-Private-IP'

Then run the same for VM2:
curl http://'VM2-Private-IP'

Replace 'VM1-Private-IP' and 'VM2-Private-IP' with the private IPs of the web servers (VM1 and VM2) in the Non-Prod environment.
The output should show the private IP and a welcome message defined in the user data script.

### Deletion Steps

# To destroy resources in the correct order while managing dependencies in Terraform,

# it's essential to destroy resources from the "top-level" modules to the "lowest-level" ones.

# This ensures that resources dependent on others (like a VPC peering connection depending on the VPC)

# are destroyed in the proper order without causing issues.

# Step 1: Delete VPC Peering

# Navigate to the Peering directory and destroy peering resources first

cd Peering
terraform destroy

# Step 2: Delete webservers first

# Delete Prod webservers first (since they depend on the network)

cd ../Prod/webservers
terraform destroy -var-file='../prod.tfvars'

# Delete Non-Prod webservers first (since they depend on the network)

cd ../Non-Prod/webservers
terraform destroy -var-file='../nonprod.tfvars'

# Step 3: Delete networks in the last

# Delete Prod network resources (VPC, subnets, etc.) after webservers are destroyed

cd ../network
terraform destroy -var-file='../prod.tfvars'

# Delete Non-Prod network resources (VPC, subnets, etc.) after webservers are destroyed

cd ../network
terraform destroy -var-file='../nonprod.tfvars'
After performing these destroy commands all the resources created with terraform will be cleaned up.

### Disclaimer

Please note that while every effort has been made to structure and name resources consistently across the project, there may be occasional errors or inconsistencies in the naming conventions and project structure. These discrepancies could arise due to iterative development and changes made throughout the lifecycle of the infrastructure.
I strongly recommend yo carefully review the resources before running `terraform apply` or `terraform destroy` to ensure they match your environment and use case. If you encounter any issues or have suggestions for improvements, please feel free to contribute or raise an issue.
