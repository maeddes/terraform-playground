resource "aws_instance" "mhs-instance" {
  ami           = "ami-a042f4d8"
  instance_type = "t2.micro"
}