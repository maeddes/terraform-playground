output "ip" {
    value = "${aws_instance.jsa-tf-ubuntu.public_ip}"
}