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
