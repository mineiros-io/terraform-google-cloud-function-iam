module "test" {
  source = "../.."

  module_enabled = false

  # add all required arguments

  cloud_function = "test"

  # add all optional arguments that create additional/extended resources

  # add most/all other optional arguments
}
