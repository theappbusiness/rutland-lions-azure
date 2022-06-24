resource "random_string" "computer_name_suffix" {
  length  = 4
  special = false
}

resource "random_password" "vm_admin_password" {
  length           = 32
  special          = true
  override_special = "#&-_+"
  min_lower        = 2
  min_upper        = 2
  min_numeric      = 2
  min_special      = 2
}
