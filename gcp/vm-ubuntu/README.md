## Connecting to the Ubuntu VM

This method requires the gcloud cli with authorized Cloud SDK tools:

```bash
    $ gcloud compute ssh --project=<project-id> --zone=<zone> <VM name>
```
 An alternative method using SSH with security keys is described here:
 https://cloud.google.com/compute/docs/tutorials/ssh-with-sk
