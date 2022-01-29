resource "aws_cloudwatch_event_rule" "daily-woot-results" {
  name        = "daily-woot-results"
  schedule_expression = "cron(0 12 * * ? *)"
}

resource "aws_cloudwatch_event_target" "sns" {
  rule      = aws_cloudwatch_event_rule.daily-woot-results.name
  target_id = "SendToSNS"
  arn       = aws_lambda_function.woot-lambda.arn
}

resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.woot-lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.daily-woot-results.arn
}