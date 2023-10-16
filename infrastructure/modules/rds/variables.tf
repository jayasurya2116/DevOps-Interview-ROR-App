variable "db_instance_identifier" {
  description = "Identifier for the RDS instance"
  type        = string
}

variable "db_password" {
  description = "rds db pass"
}

variable "rds_port" {
  description = "rds port number"
  type = number
}
