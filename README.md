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

### Infrastructure

The platform i used for the virtual machines hosting is AWS, that is for two main reasons:
- Easy integration with IaC services, such as Terraform
- All the infrastructure needed for this project falls in the AWS free plan.

In particular, the VMs are **t3.medium** EC2 instances, with the following specs:
- 2 vCpus
- 4 Gb RAM
- 5 Gbit max band burst

This relatively small VMs should be able to run a Kubernetes cluster based on **k3s**, a lighter version than usually deployed **k8s**.

Regarding the network infrastructure the most important components are:
- **Vpc** with a single subnet
- **Internet gateway** to allow the VMs to download updates and installation packets
- **Security groups** for master and worker nodes. They are configured as such:
    - **Ingress traffic** - port 6443/tcp, 22/tcp onfly for master node and 443/tcp, 80/tcp, 8472/udp for both master and workers 
    - **Internal traffic** - all traffic allowed from workers to master and port 6443/tcp, 10250/tcp from master to workers
    - **Egress traffic** - all traffic allowed

The security configuration is based on the suggested configs provided by [k3s installation guide](https://docs.k3s.io/installation/requirements#network).

### Provisioning instructions
The infrastructure is provisioned using Terraform. The whole infrastracture is described in three files:
- `main.tf`
- `vpc.tf`
- `security_group.tf`

#### Requirements:
- Terraform cli installed (~> 5.0 version)
- Working AWS account with IAM role and access keys
- SSH keypair

First you have to generate the ssh keys that will be used for vm connection and configuration

    ssh-keygen -b 2048 -t rsa

The keys shall be named `ssh-key` and moved in `env/` directory.

Then you will need to move inside the `vm-provision/` directory

    cd vm-provision/

Now you will need to create the `terraform.tfvars` file

    touch terraform.tfvars

Then you will need to compile it with the required data

    access_key = "access-key"
    secret_key = "secret_key"
    region = "eu-central-1"
    trusted_ip = "your ip"
    availability_zones = [ "eu-central-1a"]

Now the configuration is complete, you can initialise the Terraform project and provision the infrastracture. 

    terraform init
    terraform plan
    terraform apply -auto-approve

Terraform also takes care of the initial configuration of the vms, like the creation and configuration of the user `ansible` and simple dependencies installation (such as `python3`). The init commands can be found in the `init-master` and `init-worker` files.

Terraform will also provide the `master public ip address` as output of the `terraform apply`. Make sure to save the address as it will be necessary for the cluster configuration.


## K3s cluster setup

### K3s installation
The vm configuration and k3s installation is carried out using Ansible. The tool is executed by the master vm, that acts a `control node`, so the first required step is the connection to the vm

    cd cluster-setup
    
    ssh ansible@master-public-address -i ../env/ssh-key

The address of the master node is the one provided by the previous steps. If the error `access denied: public key` error shows up just wait a few minutes, then try again with the connection (the vm is not fully configured yet, therefore the public key has not been added to the authorized hosts).




References:
- [Terraform provider for AWS](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance)
- [K3s website](https://k3s.io/)