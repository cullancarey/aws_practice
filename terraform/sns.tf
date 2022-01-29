resource "aws_sns_topic" "woot-results" {
  name = "woot-results"
}

resource "aws_sns_topic_subscription" "sns_cullan" {
  topic_arn = aws_sns_topic.woot-results.arn
  protocol  = "email"
  endpoint  = "cullancarey@yahoo.com"
}

resource "aws_sns_topic_subscription" "sns_mary" {
  topic_arn = aws_sns_topic.woot-results.arn
  protocol  = "email"
  endpoint  = "mc0209409@lmc.edu"
}

resource "aws_sns_topic_subscription" "sns_dad" {
  topic_arn = aws_sns_topic.woot-results.arn
  protocol  = "email"
  endpoint  = "michaelscarey4768@gmail.com"
}