variable "ecs_cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
}

variable "rails_app_container_url" {
  description = "Rails app Container image URL"
  type = string
}

variable "webserver_container_url" {
  description = "Webserver Container image URL"
  type = string
}

variable "rails_app_container_port" {
  description = "Rails app Container port number"
  type = number
}

variable "rails_app_host_port" {
  description = "Rails app host Container port number"
  type = number
}

variable "webserver_container_port" {
  description = "Webserver container port number"
  type = number
}

variable "webserver_host_port" {
  description = "Webserver Host port number"
  type = number
}

variable "db_password" {
  description = "rds db pass"
}

variable "rds_port" {
  description = "rds port number"
  type = number
}
