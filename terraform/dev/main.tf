module "ecr" {
  source  = "terraform-aws-modules/ecr/aws"
  version = ">= 1.0"

  repository_name                 = "micronomy-dev"
  repository_image_tag_mutability = "IMMUTABLE"

  repository_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep last 30 images"
        selection = {
          tagStatus     = "tagged"
          tagPrefixList = ["v"]
          countType     = "imageCountMoreThan"
          countNumber   = 30
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}

module "ecs" {
  source = "terraform-aws-modules/ecs/aws"

  cluster_name = "micronomy-dev-cluster"

  cluster_configuration = {
    execute_command_configuration = {
      logging = "OVERRIDE"
      log_configuration = {
        cloud_watch_log_group_name = "/aws/ecs/micronomy-dev"
      }
    }
  }

  # Cluster capacity providers - Fargate only for dev
  cluster_capacity_providers = ["FARGATE"]
  default_capacity_provider_strategy = {
    FARGATE = {
      weight = 100
      base   = 2
    }
  }
}
