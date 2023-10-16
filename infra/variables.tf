

 variable "aws_region" {
  default = "us-east-1"
}

variable "aws_profile" {
  default = "surya-profile"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "aws_region_names" {
  default = ["us-east-1"]
}

variable "private_subnet_cidr_blocks" {
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}
variable "public_subnet_cidr_blocks" {
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}
variable "rails_app_container_url" {
  default = "657712095031.dkr.ecr.us-east-1.amazonaws.com/surya-mallow:rails_app"
}


variable "webserver_container_url" {
  default = "657712095031.dkr.ecr.us-east-1.amazonaws.com/surya-mallow:webserver"
}

variable "rails_app_container_port" {
  default = 3000
}
variable "rails_app_host_port" {
  default = 3000
}

variable "webserver_container_port" {
  default = 80
}
variable "webserver_host_port" {
  default = 80
}

variable "db_password" {
  description = "rds db pass"
}

variable "rds_port" {
  default = 5432
}
