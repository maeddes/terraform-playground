## Demo for statefile and (sensitive) variables in backend

The terraform state file which is Terraforms source of truth about the state of any deployed resources can be stored in a remote backend such as Terraform Cloud.
Terraform recommends to do so in any production environment or when any meaningful infrastructure is managed due to the advantages it provides in safety and ease of collaboration with multiple team members working on the same project.

More here: https://learn.hashicorp.com/collections/terraform/cloud-get-started
