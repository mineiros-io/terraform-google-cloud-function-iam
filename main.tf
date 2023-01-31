locals {
  create_binding = var.module_enabled && var.policy_bindings == null && var.role != null && var.authoritative
  create_member  = var.module_enabled && var.policy_bindings == null && var.role != null && var.authoritative == false
  create_policy  = var.module_enabled && var.policy_bindings != null
}

resource "google_cloudfunctions_function_iam_binding" "binding" {
  count = local.create_binding ? 1 : 0

  cloud_function = var.cloud_function
  region         = var.region
  role           = var.role
  members        = [for m in var.members : try(var.computed_members_map[regex("^computed:(.*)", m)[0]], m)]
  project        = var.project

  depends_on = [var.module_depends_on]
}

resource "google_cloudfunctions_function_iam_member" "member" {
  for_each = local.create_member ? var.members : []

  cloud_function = var.cloud_function
  region         = var.region
  role           = var.role
  member         = try(var.computed_members_map[regex("^computed:(.*)", each.value)[0]], each.value)
  project        = var.project

  depends_on = [var.module_depends_on]
}

resource "google_cloudfunctions_function_iam_policy" "policy" {
  count = local.create_policy ? 1 : 0

  cloud_function = var.cloud_function
  region         = var.region
  policy_data    = try(data.google_iam_policy.policy[0].policy_data, null)
  project        = var.project

  depends_on = [var.module_depends_on]
}

data "google_iam_policy" "policy" {
  count = local.create_policy ? 1 : 0

  dynamic "binding" {
    for_each = var.policy_bindings

    content {
      role    = binding.value.role
      members = [for m in binding.value.members : try(var.computed_members_map[regex("^computed:(.*)", m)[0]], m)]

      dynamic "condition" {
        for_each = try([binding.value.condition], [])

        content {
          expression  = condition.value.expression
          title       = condition.value.title
          description = try(condition.value.description, null)
        }
      }
    }
  }
}
