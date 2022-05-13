variable "env_name" {
  default = "dev"
}


variable "cloudwatch_log_retention" {
  default = 7
}

variable "region" {
  default = "us-east-1"
}

variable "build_user" {
  default = "xxxxxx"
}
variable "app" {
  default = "php"
}


variable "cpu" {
  default = 512
}
variable "memory" {
  default = 1024
}
variable "service_desired_count" {
  default = 1
}
variable "image_version" {
  description = "Version of docker image"
  default     = "111"
}

variable "app_name" {
  default = "php"
}


variable "cloudwatch_log_group_retention_days" {
  default = "30"
}
