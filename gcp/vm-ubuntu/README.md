# Simple Ubuntu VM

## Terraform files

For better overview the terraform code is structured into multiple files. 
The file `terraform.tf` specifies the required providers including version, in this case the google provider in the version 3.5.0.\
Information on the google provider such as the path to the local credentials file are defined in `provider.tf` and the actual resources definitions are placed in `resources.tf`.

## Basic Terraform workflow

After identifying the required cloud resources and creating the corresponding terraform files the typical workflow looks something like this:

```bash
$ terraform init
```
The init command installs and configures the required terraform providers. 

```bash
$ terraform plan
```
The plan command creates a preview of the changes that will be made to the currently deployed resources.

```bash
$ terraform apply
```
The apply command will execute those changes.

```bash
$ terraform destroy
```
The destroy command will tear down the deployed infrastructure.

To keep track of deployed resources Terraform manages those in a file defining the current state, the `terraform.tfstate` file.\
 In a later chapter the safe and efficient management of this extremely important file will be discussed, for a simple test project it is sufficient to keep it in the local directory where it will be created automatically.


## Connecting to the Ubuntu VM

There are several ways how a SSH connection to a Linux VM can be established, four methods will be described here in short, including  their advantages and disadvantages. Of course each project has different requirements and choosing the appropriate method is important to achieve a sufficient level of security while keeping the configuration simple.

### Google Cloud CLI

Google Cloud Platform provides several ways of connecting to VM's 
The simplest method requires the gcloud CLI with authorized Cloud SDK tools:

```bash
$ gcloud compute ssh --project=<project-id> --zone=<zone> <VM name>
```
By connecting using the Google CLI there are no other further steps and configuration required, therefore it is the quickest and simplest way to connect, not requiring further configuration also reduces the chance of introducing security issues by erroneous configuration.\
The obvious disadvantage is the requirement for the installed and configured Google CLI, a third-party without won't be able to connect and make use of this VM.

### SSH keys managed in VM metadata manually

Another simple option is to directly manage SSH keys in the metadata of the VM manually by hand. After creating a key pair using a tool such as `ssh-keygen` on Linux the public key is embedded into the metadata of the GCloud Compute Instance as a key-value pair:

```terraform
 metadata = {
    "ssh-keys" = "[USERNAME]:ssh-rsa [KEY] [USERNAME]"
  }
```

Now a connection can be established with the standard ssh command.
```bash
$ ssh -i /path/to/identity-file user@external-ip-address
```

With this setup it is easy to allow any user to access the machine, however due to the manual management of the individual keys by hand human error might introduce security risks such as keys that are due to be deleted are forgotten. Some of that risk might be mitigated by assigning expiry dates to all keys, however the approach of manual management of SSH keys in metadata is discouraged by Google.

### Connect via service accounts

It is possible to enable OS Login and also allow external users without a Google Cloud Platform account to access the machines, the setup to achieve this however is a little more complex and requires more steps. The basic idea is to use a service account to still allow for access management to be done via IAM while not requiring a Google Cloud Platform account to establish a connection.

First a service-account needs to be created and added inside the code block for the VM:

```terraform
resource "google_service_account" "jsa_service_account" {
  account_id = "jsa-sa"
}

resource "google_compute_instance" "jsa_vm_instance_sa" {

...

  metadata = {
    enable-oslogin = "TRUE"
  }

  service_account {
    email = "jsa-temp@active-woodland-324808.iam.gserviceaccount.com"
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }

...

}
```

Terraform is able to execute a local script to complete the setup:
```terraform
provisioner "local-exec" {
  command = "./local_scripts/iam-setup.sh"
}
```
This script completes the setup for the service account to allow access to the VM. It assigns the required roles to the service account, creates required keys and saves the username in a simple .txt file. By using this username, the external IP of the VM and the private key that has been created the machine can be accessed from any computer with an SSH client.