provider "aws" {
  region = "us-east-1"  # Change to your region
}

resource "aws_ecs_cluster" "node_cluster" {
  name = "node-cluster"
}

resource "aws_ecs_task_definition" "node_task" {
  family                   = "node-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"

  container_definitions = jsonencode([
    {
      name      = "node-app"
      image     = "your-dockerhub-username/node-app:latest"  # Change to your Docker image
      cpu       = 256
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "node_service" {
  name            = "node-service"
  cluster         = aws_ecs_cluster.node_cluster.id
  task_definition = aws_ecs_task_definition.node_task.arn
  desired_count   = 2
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = ["subnet-12345678"]  # Replace with your subnet ID
    security_groups = ["sg-12345678"]  # Replace with your security group ID
  }
}