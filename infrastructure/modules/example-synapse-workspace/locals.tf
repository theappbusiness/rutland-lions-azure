locals {
  module_name = "example-synapse"

  tags = merge(
    var.tags,
    {
      Module = local.module_name
    }
  )
}
