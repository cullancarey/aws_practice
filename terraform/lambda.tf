resource "aws_iam_role" "iam_for_lambda" {
  name = "woot-results-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "lambda.amazonaws.com"
        ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}


resource "aws_iam_policy" "lambda_role" {
  name        = "woot-results-policy"
  path        = "/"

  policy = <<EOF
{
  "Statement": [
    {
      "Action": [
        "logs:CreateLogStream",
        "sns:Publish",
        "ssm:GetParametersByPath",
        "ssm:GetParameters",
        "logs:PutLogEvents",
        "ssm:GetParameter"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:logs:us-east-2:${local.account_id}:log-group:/aws/lambda/woot-results:*",
        "arn:aws:ssm:*:${local.account_id}:parameter/*",
        "arn:aws:sns:us-east-2:${local.account_id}:*"
      ],
      "Sid": "VisualEditor0"
    },
    {
      "Action": "logs:CreateLogGroup",
      "Effect": "Allow",
      "Resource": "arn:aws:logs:us-east-2:${local.account_id}:*",
      "Sid": "VisualEditor1"
    },
    {
      "Action": "ssm:DescribeParameters",
      "Effect": "Allow",
      "Resource": "*",
      "Sid": "VisualEditor2"
    }
  ],
  "Version": "2012-10-17"
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.lambda_role.arn
}


resource "aws_lambda_function" "woot-lambda" {
  filename      = "lambda_function.zip"
  function_name = "woot-results"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "lambda_function.lambda_handler"
  timeout       = 30

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  source_code_hash = filebase64sha256("lambda_function.zip")

  runtime = "python3.9"

}