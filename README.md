# Kiratech-DevOps-challenge

The project is born as a code challenge, the purpose of which is to configure a kubernetes cluster and deploy some applications on it. The process has to be fully automatic and designed with IaC pattern

## Project requirements
The cluster must be composed of a **master** and **two workers**, thus the infrastructure has to run on three separate vm. 
The tool used for the virtual machines provisioning can be chosen as desired. The infrastructure and virtual machines has to follow the "minimum privilege" principle.

The VMs have to be configured using **Ansible**.

The kubernetes cluster has to be installed using **Terraform**. The same tool has to be used to create a namespace named *"kiratech-test"* and to run a security benchmark.

The application has to be deployed through an **Helm chart** and must be composed of at least three services.

The last step is to configure the **continuous integration** and the code linting.


## Virtual Machine provisioning

### infrastructure

The platform i used for the virtual machines hosting is AWS, that is for two main reasons:
- Easy integration with IaC services, such as Terraform
- All the infrastructure needed for this project falls in the AWS free plan.

In particular, the VMs are **t3.micro** EC2 instances, with the following specs:
- 2 vCpus
- 1 Gb RAM
- 5 Gbit max band burst

This small VMs should be able to run a Kubernetes cluster based on **k3s**, a lighter version than usually deployed **k8s**.

Regarding the network infrastructure the most important components are:
- **Vpc** with a single subnet
- **Internet gateway** to allow the VMs to download updates and installation packets
- **Security groups** for master and worker nodes. They are configured as such:
    - Port 22 inboud traffic only from trusted ips, used for the vm configuration and cluster installation
    - Port 6443 between master and worker nodes, default communication port used by k3s
    - All outbound traffic allowed

The infrastructure is provisioned using Terraform
### Provisioning instructions
Requirements:
- Terraform cli installed (~> 5.0 version)
- Working AWS account with IAM role and access keys
- SSH keypair

First you have to generate the ssh keys that will be used for vm connection and configuration

    ssh-keygen -b 2048 -t rsa

The keys shall be named `ssh-key` and moved in `env/` directory.

Then you will need to move inside the `vm_provision/` directory

    cd vm_provision/

Now you will need to create the `terraform.tfvars` file

    touch terraform.tfstate

Then you will need to compile it with the following data

    access_key = "access-key"
    secret_key = "secret_key"
    region = "eu-central-1"
    trusted_ip = "your ip"
    availability_zones = [ "eu-central-1a"]

Now the configuration is complete, you can initialise the Terraform project and apply the configuration

    terraform init
    terraform plan
    terraform apply -auto-approve