## AWS create and connect to Ubuntu VM

1. Create a key pair in AWS [(How-to)](https://docs.aws.amazon.com/cli/latest/userguide/cli-services-ec2-keypairs.html#deleting-a-key-pair)

2. Extract public key

    ```bash
    $ ssh-keygen -y -f /path/to/file.pem > public_key.pub
    ```

3. Import key pair into terraform

    ```bash
    $ terraform import aws_key_pair.resource-name key-name
    ```

4. Create infrastructure in terraform

5. Connect via SSH to the default User

    ```bash
    $ sh util/connect.sh

    ```

6. Create new sudo user with SSH access on EC2 Ubuntu instance [(How-to)](https://aws.amazon.com/premiumsupport/knowledge-center/new-user-accounts-linux-instance/)

7. Delete default user and use newly created user
