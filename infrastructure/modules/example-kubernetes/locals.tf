locals {
  module_name = "example-kubernetes"

  tags = merge(
    var.tags,
    {
      Module = local.module_name
    }
  )
}
