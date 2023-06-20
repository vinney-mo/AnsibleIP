## Stage 2
In this stage  the project uses an Ansible playbook  automates the process of initializing Terraform, waiting for server initialization, reloading the host inventory, and then configuring Docker and deploying containers on the target host. It combines infrastructure provisioning and configuration with container deployment using Ansible and Terraform, providing a streamlined approach to manage and deploy infrastructure and applications.

The playbook you provided is an Ansible playbook that automates the provisioning and configuration of resources, as well as the deployment of Docker containers. Let's break down the playbook and explain each section in detail:

#### 1. Provision and configure resources
The playbook targets the localhost, indicating that Ansible will run locally on the machine where it is executed.
The tasks section contains a series of tasks that will be executed sequentially.
- `Initialize Terraform`:
    - The first task is named `Initialize Terraform` and uses the `community.general.terraform` Ansible module which is responsible for initializing Terraform in a specific project directory.
    - `project_path` parameter is set to `{{ playbook_dir }}/terraform`, which means the playbook looks for the terraform directory relative to the location of the playbook itself.
    - `state` parameter is set to present to ensure that Terraform is initialized if it hasn't been already.
    - The `force_init` parameter is set to true, which forces the initialization even if the project has already been initialized.
    
    ##### `Terraform scripts`
    - `var.tf`
    The `var.tf` is a Terraform configuration file that defines variables. Variables in Terraform allow you to parameterize your infrastructure code and make it more flexible and reusable.
    There are 3 varribles defined:
        - `access_key` - created on aws and is access key is a unique identifier that is used to authenticate and authorize access to AWS resources through APIs
        - `secret_key` - is a private key that corresponds to the access key ID
        - `public_key` - refers to an SSH public key that is used for SSH key pairs created on the control node and will be used for ssh access to the newly created hosts

        These are related to AWS authentication and authorization mechanisms
        
    - `providers.tf`
    Specifies the provider and its settings. In this case, it configures the "aws" provider for the "eu-north-1" region with the specified access key and secret key. Terraform communicates with the AWS API using the provided access key and secret key, allowing you to define and manage AWS resources using Terraform's declarative language
    
    - `main.tf`
    Defines and provisions AWS resources.
    It provisions an `AWS key pair`, creates a `security group` with inbound and outbound rules, and `launches` an EC2 instance with the specified `AMI` and `instance type`. It also adds the newly created instance to the list of hosts on the Ansible control node by modifying the `/etc/ansible/hosts` file.
    
    - `terraform.tfvars`
    Created using the strucure provide in the `terraform.tfvars.example` file. It is is used to define variable values for your infrastructure configuration in this case `access_key`, `secret_key`, and `public_key` making it easier to manage and customize your Terraform deployments for different environments or scenarios without modifying the main configuration files.
    This  file is ignored from being pushed to git to avoid any leakage of senstive data.
    
- `Wait for the server to complete initializing before proceeding`:
    - The second task, named `Wait for the server to complete initializing before proceeding`, uses the pause Ansible module which introduces a pause in playbook execution for a specified duration.
    - In this case, the pause is set for 5 minutes using the minutes parameter. The purpose of this task is to allow time for the server to complete any initialization processes before proceeding to the next steps.

#### 2. Reload host file
- `Reload host file`:
    - The playbook now switches to a new play, named `Reload host file`, which is still targeting the localhost.
    - The purpose of this play is to reload the Ansible inventory to include any new hosts that were created during the provisioning process.
    - The `meta` module with the `refresh_inventory` argument is used to trigger a refresh of the host inventory.

#### 3. Configure Docker and run containers:

- The playbook moves to the final play, named `Configure Docker and run containers`.
The play targets a specific host, in this case host_1, which should be updated with the appropriate target hosts as determined by the Terraform provisioning process.
This uses the same process and roles same as those in stage 1 for `Docker installation` and `container deployment`
