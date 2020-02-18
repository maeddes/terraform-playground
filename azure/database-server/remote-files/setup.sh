sudo apt-get update
sudo apt-get -y upgrade

sudo apt-get -y install python3-pip
pip3 install pymysql

sudo apt-get -y install curl
curl -O https://www.digicert.com/CACerts/BaltimoreCyberTrustRoot.crt.pem
mv BaltimoreCyberTrustRoot.crt.pem /etc/ssl/certs/Baltimore_CyberTrust_Root.pem
