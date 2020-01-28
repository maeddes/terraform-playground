variable "key_name" {
  type = string
  default = "jsa-tf-keypair"
}

variable "ami" {
  type = string
  default = "ami-00f69856ea899baec"
}

variable "region" {
  type = string
  default = "eu-central-1"
}

variable "instance_type" {
  type = string
  default = "t2.micro"
}