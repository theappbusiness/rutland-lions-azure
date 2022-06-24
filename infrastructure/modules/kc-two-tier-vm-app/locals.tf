locals {
  module_name     = "care-compute"
  resource_suffix = can(var.resource_suffix) ? var.resource_suffix : "${local.module_name}-${var.location}-${var.environment}"

  tags = merge(
    var.tags,
    {
      Module = local.module_name
    }
  )
}
