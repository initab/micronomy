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

# ECS Task Execution Role
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "${local.app-name}-ecs-task-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

# Attach the AWS managed policy for ECS task execution
resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_ecs_task_definition" "micronomy-task-def" {
  family                   = "micronomy"
  cpu                      = "256"
  memory                   = "512"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name = "micronomy"
      # ← placeholder: any valid, pullable image works
      image = "public.ecr.aws/nginx/nginx:latest"
      portMappings = [
        { containerPort = 8080 }
      ]
    }
  ])
}

resource "aws_ecs_service" "micronomy-service" {
  name            = "micronomy"
  cluster         = module.ecs.cluster_id
  task_definition = aws_ecs_task_definition.micronomy-task-def.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = aws_subnet.public[*].id
    security_groups = aws_security_group.ecs_tasks[*].id
  }

  lifecycle {
    ignore_changes = [task_definition]
  }
}
