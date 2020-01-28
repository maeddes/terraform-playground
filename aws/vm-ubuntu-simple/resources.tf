resource "aws_key_pair" "jsa-tf-keypair" {
  key_name = var.key_name
  public_key = file("~/Documents/ssh/id_rsa.pub")
}

resource "aws_instance" "jsa-tf-ubuntu" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name = aws_key_pair.jsa-tf-keypair.key_name

  connection {
    type = "ssh"
    user = "ubuntu"
    private_key = file("~/Documents/ssh/jsa-tf-keypair.pem")
    host = self.public_ip
  }

  provisioner "file" {
    source = "./remote-scripts/script.sh"
    destination = "~/script.sh"
  }

  provisioner "file" {
    source = "./remote-scripts/create_user.sh"
    destination = "~/create_user.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x ~/script.sh",
      "chmod +x ~/create_user.sh",
      "sh script.sh",
      "sudo sh create_user.sh"
    ]
  }

  tags = {
    Name = "jsa-tf-ubuntu"
  }
}