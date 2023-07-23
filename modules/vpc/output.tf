output "main-id" {
  value = aws_vpc.main.id
}

output "subnets_ids" {
  value = [aws_subnet.private.id,aws_subnet.public.id]
}
output "sg_id" {
  value = aws_security_group.eks_cluster_sg.id
}