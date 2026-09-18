# Local variables for dev environment
locals {
  dev_subnet_ids = ["subnet-dev-1", "subnet-dev-2"]
  dev_sg_ids     = ["sg-dev-app"]
  dev_log_group  = "/aws/ecs/micronomy-dev"

  app-name = "micronomy"
}
