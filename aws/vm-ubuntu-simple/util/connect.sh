keypath="/home/julian/Documents/ssh/jsa-tf-keypair.pem"
ip=$(terraform output ip)

ssh -i $keypath ubuntu@$ip