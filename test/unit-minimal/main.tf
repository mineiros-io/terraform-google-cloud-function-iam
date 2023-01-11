module "test" {
  source = "../.."

  # add all required arguments

  cloud_function = "test"

  # add all optional arguments that create additional/extended resources

  role = "roles/viewer"

  members = ["user:user@example.com"]

  # add most/all other optional arguments
}
