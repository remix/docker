locals {
  repo_url   = "${data.aws_ecr_repository.this.repository_url}"
  task_image = "${local.repo_url}:${var.task_image_tag}"
}

locals {
  environment = [
    {
      name  = "ENVIRONMENT"
      value = "${var.environment}"
    },
    {
      name  = "S3_TILES_URL"
      value = "${var.s3_tiles_url}"
    },
  ]
}

data "aws_ecr_repository" "this" {
  name = "${var.repository}"
}

data "aws_iam_role" "task" {
  name = "${var.task_role}"
}

data "aws_iam_role" "task_execution" {
  name = "${var.task_execution_role}"
}

data "aws_lb_listener" "this" {
  arn = "${var.lb_listener_arn}"
}

resource "aws_ecs_service" "this" {
  depends_on = ["aws_lb_listener_rule.this"]

  name            = "${var.name}"
  cluster         = "${var.cluster}"
  task_definition = "${aws_ecs_task_definition.this.arn}"
  desired_count   = 1

  # It can take some time to fetch and load the tiles
  health_check_grace_period_seconds = 1800

  lifecycle {
    ignore_changes = ["desired_count"]
  }

  load_balancer {
    target_group_arn = "${aws_lb_target_group.this.arn}"
    container_name   = "web"
    container_port   = 8002
  }

  placement_constraints {
    type       = "memberOf"
    expression = "${var.placement_constraint}"
  }
}

resource "aws_ecs_task_definition" "this" {
  family = "${var.environment}-${var.name}"

  cpu    = "${var.task_cpu}"
  memory = "${var.task_memory}"

  execution_role_arn = "${data.aws_iam_role.task_execution.arn}"
  task_role_arn      = "${data.aws_iam_role.task.arn}"

  container_definitions = <<-EOF
    [
      {
        "entryPoint": ["/scripts/fetch_and_serve.sh"],
        "environment": ${jsonencode(local.environment)},
        "image": "${local.task_image}",
        "logConfiguration": {
          "logDriver": "awslogs",
          "options": {
            "awslogs-group": "${var.log_group}",
            "awslogs-region": "${var.log_region}",
            "awslogs-stream-prefix": "${var.environment}"
          }
        },
        "name": "web",
        "portMappings": [
          {
            "containerPort": 8002
          }
        ]
      }
    ]
  EOF
}

resource "aws_lb_listener_rule" "this" {
  listener_arn = "${data.aws_lb_listener.this.arn}"
  priority     = "${var.lb_listener_rule_priority}"

  action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.this.arn}"
  }

  condition {
    field  = "host-header"
    values = ["${var.lb_listener_rule_host}"]
  }
}

resource "aws_lb_target_group" "this" {
  name     = "${var.environment}-${var.name}"
  port     = 8002
  protocol = "HTTP"
  vpc_id   = "${var.vpc_id}"

  health_check {
    # Remix -> SFMTA by bus
    path = "/route?json={\"locations\":[{\"lat\":37.777421,\"lon\":-122.410172},{\"lat\":37.774875,\"lon\":-122.418809}],\"costing\":\"bus\"}"
  }

  lifecycle {
    create_before_destroy = true
  }
}
