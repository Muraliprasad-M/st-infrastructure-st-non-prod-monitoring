resource "aws_sns_topic" "alerts" {
  name = var.name
}

resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = var.email
}

variable "name" {}
variable "email" {}

output "topic_arn" {
  value = aws_sns_topic.alerts.arn
}
