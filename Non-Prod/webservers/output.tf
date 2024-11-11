# Output the instance public IP
output "vm_bastion_public_ip" {
  description = "Public IP of the Bastion VM "
  value       = aws_instance.bastion_vm.public_ip
}

# Output the instance private IP
output "vm_bastion_private_ip" {
  description = "Private IP of the Bastion VM "
  value       = aws_instance.bastion_vm.private_ip
}

# Output the instance private IP
output "vm1_private_ip" {
  description = "Private IP address of VM1"
  value       = aws_instance.private_vms["private-vm1"].private_ip
}

output "vm2_private_ip" {
  description = "Private IP address of VM2"
  value       = aws_instance.private_vms["private-vm2"].private_ip
}
