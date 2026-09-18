module "ecr" {
  source  = "terraform-aws-modules/ecr/aws"
  version = ">= 1.0"

  repository_name = "micronomy-dev"
  repository_image_tag_mutability = "IMMUTABLE"

  repository_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep last 30 images"
        selection = {
          tagStatus   = "tagged"
          tagPrefixList = ["v"]
          countType   = "imageCountMoreThan"
          countNumber = 30
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}
