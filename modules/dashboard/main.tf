resource "aws_cloudwatch_dashboard" "this" {
  dashboard_name = var.dashboard_name

  dashboard_body = jsonencode({
    widgets = [
      {
        type = "metric",
        x = 0, y = 0, width = 24, height = 6,
        properties = {
          title  = "EC2 CPU (IT NonProd)",
          region = var.region,
          stat   = "Average",
          period = 300,
          metrics = [[{
            expression = "SEARCH('{AWS/EC2,InstanceId} MetricName=\"CPUUtilization\" AND Tag:Domain=\"st\" AND Tag:Environment=\"non-prod\"', 'Average', 300)",
            id = "e1"
          }]]
        }
      },
      {
        type = "metric",
        x = 0, y = 7, width = 24, height = 6,
        properties = {
          title  = "NAT Connections",
          region = var.region,
          stat   = "Average",
          period = 300,
          metrics = [[{
            expression = "SEARCH('{AWS/NATGateway,NatGatewayId} MetricName=\"ActiveConnectionCount\"', 'Average', 300)",
            id = "e2"
          }]]
        }
      },
      {
        type = "log",
        x = 0, y = 14, width = 24, height = 6,
        properties = {
          title  = "Top Talkers",
          region = var.region,
          query  = "SOURCE '/aws/vpc/flowlogs' | stats sum(bytes) by srcAddr, dstAddr | sort sum(bytes) desc | limit 20"
        }
      }
    ]
  })
}

variable "dashboard_name" {}
variable "region" {}
