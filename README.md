# Kiratech-DevOps-challenge

The project is born as a code challenge, the purpose of which is to configure a kubernetes cluster and deploy some applications on it. The process has to be fully automatic and designed with IaC pattern

## Project requirements
The cluster must be composed of a *master* and *two workers*, thus the infrastracture has to run on three separate vm. 
The tool used for the virtual machines provisioning can be chosen as desired. The infrastracture and virtual machines has to follow the "minimum privilege" principle.

The VMs have to be configured using *Ansible*.

The kubernetes cluster has to be installed using *Terraform*. The same tool has to be used to create a namespace named *"kiratech-test"* and to run a security benchmark.

The application has to be deployed through an *Helm chart* and must be composed of at least three services.

The last step is to configure the *continuous integration* and the code linting.


## Virtual Machine provisioning
