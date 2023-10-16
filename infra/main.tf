module "network" {
  source = "./modules/network"
  vpc_cidr = var.vpc_cidr
  aws_region_names = var.aws_region_names
  private_subnet_cidr_blocks = var.private_subnet_cidr_blocks
  public_subnet_cidr_blocks = var.public_subnet_cidr_blocks
}

module "ecs" {
  source = "./modules/ecs"
  vpc_id = module.network.vpc_id
  rails_app_container_url = var.rails_app_container_url
  webserver_container_url = var.webserver_container_url
  rails_app_container_port = var.rails_app_container_port
  rails_app_host_port = var.rails_app_host_port
  webserver_container_port = var.webserver_container_port
  webserver_host_port = var.webserver_host_port
  db_password = var.db_password
}

module "rds" {
  source = "./modules/rds"
  db_password = var.db_password
}

module "s3" {
  source = "./modules/s3"
}
