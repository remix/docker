variable "name" {
  description = "Task name"
  default     = "valhalla"
}

variable "cluster" {
  description = "ECS cluster"
  default     = "default"
}

variable "environment" {
  description = "Deployment environment"
  default     = "production"
}

variable "extract_url" {
  description = "Open Street Maps extract URL"
  default     = "http://planet.osm.org/pbf/planet-latest.osm.pbf"
}

variable "iam_path" {
  description = "IAM resource path"
  default     = "/"
}

variable "lb_listener_arn" {
  description = "Load balancer listener ARN"
}

variable "lb_listener_rule_host" {
  description = "Load balancer rule host header value"
}

variable "lb_listener_rule_priority" {
  description = "Load balancer rule priority"
}

variable "log_group" {
  description = "CloudWatch Logs group"
  default     = "valhalla"
}

variable "log_region" {
  description = "CloudWatch Logs region"
  default     = "us-east-1"
}

variable "placement_constraint" {
  description = "Service placement constraint expression"
  default     = "attribute:ecs.instance-type =~ r.*"
}

variable "repository" {
  description = "Elastic Container Registry repository"
  default     = "valhalla"
}

variable "s3_tiles_url" {
  description = "S3 URL of tile archive"
}

variable "task_cpu" {
  description = "Task CPU"
  default     = 8192
}

variable "task_execution_role" {
  description = "Task execution role"
  default     = "ecsTaskExecutionRole"
}

variable "task_image_tag" {
  description = "Task container image tag"
  default     = "latest"
}

variable "task_memory" {
  description = "Task memory"
  default     = 61440
}

variable "task_role" {
  description = "Service task role"
  default     = "valhalla"
}

variable "vpc_id" {
  description = "VPC identifier"
}
