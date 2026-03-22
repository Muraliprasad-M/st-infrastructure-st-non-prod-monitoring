variable "sns_topic_arn" {}

resource "aws_cloudwatch_metric_alarm" "ec2_high_cpu" {
  alarm_name          = "ec2-fleet-high-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  threshold           = 70

  metrics = [
    {
      id = "e1"
      expression = "SEARCH('{AWS/EC2,InstanceId} MetricName=\"CPUUtilization\" AND Tag:Domain=\"st\" AND Tag:Environment=\"non-prod\"', 'Average', 300)"
    },
    {
      id = "e2"
      expression = "AVG(e1)"
    }
  ]

  alarm_actions = [var.sns_topic_arn]
}

resource "aws_cloudwatch_metric_alarm" "ec2_anomaly" {
  alarm_name          = "ec2-cpu-anomaly"
  comparison_operator = "GreaterThanUpperThreshold"
  evaluation_periods  = 2

  metrics = [
    {
      id = "e1"
      expression = "SEARCH('{AWS/EC2,InstanceId} MetricName=\"CPUUtilization\" AND Tag:Domain=\"st\" AND Tag:Environment=\"non-prod\"', 'Average', 300)"
    },
    {
      id = "e2"
      expression = "AVG(e1)"
    },
    {
      id = "ad1"
      expression = "ANOMALY_DETECTION_BAND(e2, 2)"
    }
  ]

  threshold_metric_id = "ad1"

  alarm_actions = [var.sns_topic_arn]
}

resource "aws_cloudwatch_metric_alarm" "nat_high" {
  alarm_name          = "nat-fleet-high-connections"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  threshold           = 8000

  metrics = [
    {
      id = "n1"
      expression = "SEARCH('{AWS/NATGateway,NatGatewayId} MetricName=\"ActiveConnectionCount\"', 'Average', 300)"
    },
    {
      id = "n2"
      expression = "AVG(n1)"
    }
  ]

  alarm_actions = [var.sns_topic_arn]
}
