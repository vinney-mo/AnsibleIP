# AnsibleIP
The project sets up automated Ansible configuration playbooks that automates the provisioning and configuration of resources, as well as the deployment an application.
The project is set up in two stages
- ##### Stage 1: Ansible Instrumentation `/stage_1`
- ##### Stage 2: Ansible + Terraform instrumentation `/stage_2`

## Stage 1: Ansible Instrumentation
In this stage  the project uses an Ansible playbook, to automate Docker configuration on the target hosts, install the necessary images for the `clien`t and `backend` components, and run the containers. The playbook relies on the two roles,` docker-installation` and `docker-container`s, to perform these tasks. By defining variables in the vars section, the playbook provides flexibility to customize the images used and the deployment directory.
## Stage 2: Ansible + Terraform instrumentation
In this stage  the project uses an Ansible playbook  automates the process of initializing Terraform, waiting for server initialization, reloading the host inventory, and then configuring Docker and deploying containers on the target host. It combines infrastructure provisioning and configuration with container deployment using Ansible and Terraform, providing a streamlined approach to manage and deploy infrastructure and applications.
