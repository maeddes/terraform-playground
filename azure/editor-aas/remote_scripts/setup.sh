# Install Gui
sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get -y install xfce4
sudo apt-get -y install xrdp
sudo systemctl enable xrdp
echo xfce4-session >~/.xsession
sudo service xrdp restart

# Install VS Code
sudo apt -y install software-properties-common apt-transport-https wget
wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
sudo apt -y update
sudo apt -y install code

# Add normal user with password 'newpass'
testuserpassword=$(openssl passwd -crypt newpass)
sudo useradd -m testuser -p $testuserpassword

# Clone sample project
sudo mkdir /home/testuser/Projects
cd /home/testuser/Projects
sudo git clone https://github.com/maeddes/terraform-playground.git
sudo chown -R testuser /home/testuser/Projects

# Force Testuser to change password after 1 day
chage -d 0 testuser

# Cleanup
sudo apt -y autoremove