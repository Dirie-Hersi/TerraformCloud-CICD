# --- networking/outputs.tf --- 

output "vpc_id" {
  value = aws_vpc.terraform_dnd_vpc.id
}