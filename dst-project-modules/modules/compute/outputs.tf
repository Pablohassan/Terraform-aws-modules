output "public_ip" {
  value = aws_instance.ec2_public.public_ip
}
#ip de l'instance privée
output "private_ip" {
  value = aws_instance.ec2_private.private_ip
}