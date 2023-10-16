variable "vpc_cidr" {
  description = "Main VPC CIDR"
  type        = string
}

variable "aws_region_names" {
  description = "Availability zone names"
  type        = list(string)
}

variable "private_subnet_cidr_blocks" {
  description = "Private subnet CIDR blocks"
  type        = list(string)
}

variable "public_subnet_cidr_blocks" {
  description = "Public subnet CIDR blocks"
  type        = list(string)
}
