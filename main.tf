module "sns" {
  source = "./modules/sns"

  name  = "${var.prefix}-sns-alerts"
  email = var.alert_email
}

module "dashboard" {
  source = "./modules/dashboard"

  dashboard_name = "${var.prefix}-dashboard"
  region         = var.region
}

module "alarms" {
  source = "./modules/alarms"

  sns_topic_arn = module.sns.topic_arn
}
