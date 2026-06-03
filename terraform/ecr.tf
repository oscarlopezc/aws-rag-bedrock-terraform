resource "aws_ecr_repository" "backend" {
  name = "sre-backend"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "sre-backend"
  }
}

resource "aws_ecr_repository" "frontend" {
  name = "sre-frontend"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "sre-frontend"
  }
}