## Stage 1
In this stage  the project uses an Ansible playbook, which is a configuration management tool used to automate the deployment. 

This playbook aims to configure Docker on the target hosts, install the necessary images for the `clien`t and `backend` components, and run the containers. The playbook relies on the two roles,` docker-installation` and `docker-container`s, to perform these tasks. By defining variables in the vars section, the playbook provides flexibility to customize the images used and the deployment directory.
Here are some definations of the playbook.

- `name`: This is the name given to the playbook. In this case, it is `Configure Docker and run containers`, which provides a brief description of the playbook's purpose.

- `hosts`: This line specifies the target hosts on which the playbook will be executed. The keyword `all` indicates that the playbook will be applied to all hosts defined in the Ansible inventory file. You can replace "all" with specific host names or groups to limit the playbook execution to specific hosts.

- `gather_facts`: This option determines whether Ansible should gather facts about the target hosts before executing tasks. In this playbook, it is set to false, indicating that Ansible will not collect information about the hosts. Gathering facts can be useful to access system details like network interfaces, installed packages, or system architecture, but it may not be necessary for this specific playbook.

- `vars`: This section defines variables that will be used throughout the playbook. Here are the variables and their meanings:

    - `client_image`: Specifies the Docker image to be used for the client component. It is set to `viper0418/client:v1.0.0`.
     - `backend_image`: Specifies the Docker image to be used for the backend component. It is set to `viper0418/backend:v1.0.0`.
     - `app_folder`: Specifies the directory path where the application files will be deployed on the target hosts. It is set to `/opt/yolo`.

- `roles`: This section specifies the roles that will be executed as part of the playbook. Roles are reusable collections of tasks, handlers, and variables that can be applied to different hosts. In this playbook, two roles are specified:

    - `docker-installation`: This role is responsible for installing Docker on the target hosts.
    - `docker-containers`: This role is responsible for running the Docker containers using the specified images and configuring them as required.
