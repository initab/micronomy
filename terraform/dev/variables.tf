variable "region" {
  description = "AWS region for infrastructure deployment"
  type        = string
  default     = "eu-north-1"
}

variable "app_service_desired_count" {
  description = "Desired number of app service instances"
  type        = number
  default     = 1
}

variable "github_org" {
  description = "GitHub organization name"
  type        = string
  default     = "initab"
}

variable "github_repo" {
  description = "GitHub repository name"
  type        = string
  default     = "micronomy"
}
