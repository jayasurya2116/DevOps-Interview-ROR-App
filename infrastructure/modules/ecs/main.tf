# Create an ECS cluster
resource "aws_ecs_cluster" "ecs_cluster_rails" {
  name = "my-ecs-cluster"
}


resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecs_task_execution_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com",
        },
      },
    ],
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  role       = aws_iam_role.ecs_task_execution_role.name
}




#defining the load balancer

resource "aws_alb" "ecs-alb" {
  name                = "ecs-alb"
  load_balancer_type  = "application"
  subnets             = aws_subnet.public_subnets[*].id
  security_groups     = [aws_security_group.ecs_alb_security_group.id]
}

resource "aws_alb_target_group" "alb-tg" {
  name        = "alb-target-group"
  port        = var.webserver_container_port
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main_vpc.id
  target_type = "ip"
}

resource "aws_alb_listener" "alb-lsnr" {
  load_balancer_arn = aws_alb.ecs-alb.arn
  port              = "80"
  protocol          = "HTTP"
  

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.alb-tg.arn
  }
}


# Define your task definition here
resource "aws_ecs_task_definition" "ecs_task" {
  family                   = "my-app-task-family"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  memory                   = 512
  cpu                      = 256

  container_definitions = jsonencode([
    {
      name  = "rails-app-container"
      image = var.rails_app_container_url
      environment = [
        {"name": "RDS_DB_NAME", "value": tostring(aws_db_instance.my_rds_instance.db_name)},
        {"name": "RDS_USERNAME", "value": tostring(aws_db_instance.my_rds_instance.username)},
        {"name": "RDS_PASSWORD", "value": tostring(var.db_password)},
        {"name": "RDS_HOSTNAME", "value": tostring(aws_db_instance.my_rds_instance.address)},
        {"name": "RDS_PORT", "value": tostring(var.rds_port)},
        {"name": "S3_BUCKET_NAME", "value": tostring(aws_s3_bucket.rails_s3_bucket.bucket)},
        {"name": "S3_REGION_NAME", "value": tostring(aws_s3_bucket.rails_s3_bucket.region)},
        {"name": "LB_ENDPOINT", "value": tostring(aws_alb.ecs-alb.dns_name)}
      ]


      portMappings = [
        {
          containerPort = var.rails_app_container_port
          hostPort      = var.rails_app_host_port
        }
      ]
    },
    {
      name  = "webserver-container"
      image = var.webserver_container_url


      portMappings = [
        {
          containerPort = var.webserver_container_port
          hostPort      = var.webserver_host_port
        }
      ]
    }
  ])                        
}

# Create an ECS service here
resource "aws_ecs_service" "ecs_service" {
  name            = "my-ecs-service"
  cluster         = aws_ecs_cluster.ecs_cluster_rails.id
  task_definition = aws_ecs_task_definition.ecs_task.arn
  desired_count     = 2
  launch_type       = "FARGATE"

   network_configuration {
    subnets             = aws_subnet.private_subnets[*].id
    assign_public_ip    = true
    security_groups     = [aws_security_group.ecs_alb_security_group.id]
  }

  load_balancer {
    target_group_arn    = aws_alb_target_group.alb-tg.arn
    container_name      = "webserver-container"
    container_port      = var.webserver_container_port
  }
}

# Output the ECS cluster name
output "ecs_cluster_name" {
  value = aws_ecs_cluster.ecs_cluster_rails.name
}

resource "aws_security_group" "ecs_alb_security_group" {
  vpc_id = aws_vpc.main_vpc.id  
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}