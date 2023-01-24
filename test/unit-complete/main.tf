module "test-sa" {
  source = "github.com/mineiros-io/terraform-google-service-account?ref=v0.1.1"

  account_id = "service-account-id-${local.random_suffix}"
}

module "test" {
  source = "../.."

  # add all required arguments

  cloud_function = "test"

  # add all optional arguments that create additional/extended resources

  role = "roles/viewer"

  members = [
    "allUsers",
    "allAuthenticatedUsers",
    "user:user@${local.org_domain}",
    "serviceAccount:service-account-name@${local.project_id}.iam.gserviceaccount.com",
    "group:group@${local.org_domain}",
    "domain:${local.org_domain}",
    "projectOwner:${local.project_id}",
    "projectEditor:${local.project_id}",
    "projectViewer:${local.project_id}",
    "computed:myserviceaccount"
  ]
  computed_members_map = {
    myserviceaccount = "serviceAccount:${module.test-sa.service_account.email}"
  }
  # add most/all other optional arguments

  authoritative = false
}

module "test2" {
  source = "../.."

  # add all required arguments

  cloud_function = "test"

  # add all optional arguments that create additional/extended resources

  role = "roles/viewer"

  members = [
    "user:member@example.com",
    "computed:myserviceaccount",
  ]
  computed_members_map = {
    myserviceaccount = "serviceAccount:${module.test-sa.service_account.email}"
  }
  # add most/all other optional arguments
}

module "test3" {
  source = "../.."

  # add all required arguments

  cloud_function = "test"

  # add all optional arguments that create additional/extended resources

  policy_bindings = [
    {
      role = "roles/viewer"
      members = [
        "user:member@example.com",
        "computed:myserviceaccount",
      ]
    },
    {
      role = "roles/browser"
      members = [
        "user:member@example.com",
      ]
      condition = {
        expression = "request.time < timestamp(\"2023-01-01T00:00:00Z\")"
        title      = "expires_after_2023_12_31"
      }
    }
  ]

  computed_members_map = {
    myserviceaccount = "serviceAccount:${module.test-sa.service_account.email}"
  }

  # add most/all other optional arguments
}
