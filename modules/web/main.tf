resource "aws_lb" "web" {
  name               = "web-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.web_alb_sg_id]
  subnets            = var.public_subnet_ids
}

resource "aws_launch_template" "web" {
  name_prefix   = "web-"
  image_id      = data.aws_ami.amazon_linux_2.id
  instance_type = var.web_instance_type
  key_name      = var.key_name

  network_interfaces {
    security_groups = [var.web_instance_sg_id]
  }

  user_data = base64encode(<<-EOF
              #!/bin/bash
              echo "<h1>Web Tier Works!</h1><p>Instance: $(hostname)</p>" > /tmp/index.html
              cd /tmp
              nohup python3 -m http.server 80 > /tmp/http.log 2>&1 &
              sleep 5
              EOF
              )
}

resource "aws_lb_target_group" "web" {
  name     = "web-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    enabled             = true
    healthy_threshold   = 2
    interval            = 30
    matcher             = "200"
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 10
    unhealthy_threshold = 10
  }
}

resource "aws_lb_listener" "web_http" {
  load_balancer_arn = aws_lb.web.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web.arn
  }
}

resource "aws_autoscaling_group" "web" {
  desired_capacity   = 2
  max_size           = 4
  min_size           = 2
  vpc_zone_identifier = var.public_subnet_ids
  target_group_arns   = [aws_lb_target_group.web.arn]

  launch_template {
    id      = aws_launch_template.web.id
    version = "$Latest"
  }
}