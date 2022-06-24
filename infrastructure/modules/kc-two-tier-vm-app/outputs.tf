output "vm_admin_password" {
  description = "The local administrator password for compute instances"
  value       = random_password.vm_admin_password.result
}
