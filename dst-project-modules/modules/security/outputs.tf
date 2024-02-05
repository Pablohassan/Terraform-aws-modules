output "db_sg_id" {
  value = aws_security_group.db_sg.id
  
}
output "webserver_sg" {
  value = aws_security_group.webserver_sg.id

}

output "security_group_elb_sg" {
  value = aws_security_group.elb_sg.id

}


output "db_security_group" {
  value = aws_security_group.db_sg.id

}

output "elb_sg_id" {
  value = aws_security_group.elb_sg.id
}
output "bastion_sg_22" {

  value = aws_security_group.bastion_sg_22.id
}