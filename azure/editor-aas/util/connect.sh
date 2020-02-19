keypath="/home/julian/Documents/ssh/jsa-tf-eaas.pem"
ip=$(terraform output ip_address)

ssh -i $keypath testadmin@$ip