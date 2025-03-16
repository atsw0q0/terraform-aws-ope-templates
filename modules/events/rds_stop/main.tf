locals {
  #   create_iam_role = var.iam_role_prefix.is_create_iam_role ? 1 : 0
  #   flow_log_destination_arn = local.create_iam_role ? try(aws_cloudwatch_log_group.main[0].arn, null) : var.flow_log_destination_arn
  create_iam_role      = var.iam_role_prefix.is_create_iam_role ? 1 : 0
  lambda_function_name = format("%s-%s-lambda-rdsStop-%02d", var.pj_tags.name, var.pj_tags.env, 1)
}


data "aws_iam_policy_document" "lambda_assume_role" {
  count = var.iam_role_prefix.is_create_iam_role ? 1 : 0
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "rds_stop" {
  count = var.iam_role_prefix.is_create_iam_role ? 1 : 0
  statement {
    effect = "Allow"
    actions = [
      "rds:DescribeDBInstances",
      "rds:DescribeDBClusters",
      "rds:StopDBInstance",
      "rds:StopDBCluster"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "rds_stop" {
  count  = var.iam_role_prefix.is_create_iam_role ? 1 : 0
  name   = format("%s-%s-iam-policy-lambda-rdsStop-%02d", var.pj_tags.name, var.pj_tags.env, 1)
  policy = data.aws_iam_policy_document.rds_stop[0].json
  tags = {
    Name = format("%s-%s-iam-policy-lambda-rdsStop-%02d", var.pj_tags.name, var.pj_tags.env, 1)
    PJ   = var.pj_tags.name
    Env  = var.pj_tags.env
  }
}

resource "aws_iam_role" "lambda" {
  count              = var.iam_role_prefix.is_create_iam_role ? 1 : 0
  name               = format("%s-%s-iam-role-lambda-rdsStop-%02d", var.pj_tags.name, var.pj_tags.env, 1)
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role[0].json
  tags = {
    Name = format("%s-%s-iam-role-lambda-rdsStop-%02d", var.pj_tags.name, var.pj_tags.env, 1)
    PJ   = var.pj_tags.name
    Env  = var.pj_tags.env
  }
}

resource "aws_iam_role_policy_attachment" "rds_stop" {
  count      = var.iam_role_prefix.is_create_iam_role ? 1 : 0
  role       = aws_iam_role.lambda[0].name
  policy_arn = aws_iam_policy.rds_stop[0].arn
}

resource "aws_iam_role_policy_attachment" "lambda_execute" {
  count      = var.iam_role_prefix.is_create_iam_role ? 1 : 0
  role       = aws_iam_role.lambda[0].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}


data "aws_iam_policy_document" "events_assume_role" {
  count = var.iam_role_prefix.is_create_iam_role ? 1 : 0
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "lambda_invoke" {
  count = var.iam_role_prefix.is_create_iam_role ? 1 : 0
  statement {
    effect = "Allow"
    actions = [
      "lambda:InvokeFunction"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "events" {
  count  = var.iam_role_prefix.is_create_iam_role ? 1 : 0
  name   = format("%s-%s-iam-policy-events-rdsStop-%02d", var.pj_tags.name, var.pj_tags.env, 1)
  policy = data.aws_iam_policy_document.lambda_invoke[0].json
  tags = {
    Name = format("%s-%s-iam-policy-events-rdsStop-%02d", var.pj_tags.name, var.pj_tags.env, 1)
    PJ   = var.pj_tags.name
    Env  = var.pj_tags.env
  }
}

resource "aws_iam_role" "events" {
  count              = var.iam_role_prefix.is_create_iam_role ? 1 : 0
  name               = format("%s-%s-iam-role-events-rdsStop-%02d", var.pj_tags.name, var.pj_tags.env, 1)
  assume_role_policy = data.aws_iam_policy_document.events_assume_role[0].json
  tags = {
    Name = format("%s-%s-iam-role-events-rdsStop-%02d", var.pj_tags.name, var.pj_tags.env, 1)
    PJ   = var.pj_tags.name
    Env  = var.pj_tags.env
  }
}

resource "aws_iam_role_policy_attachment" "events" {
  count      = var.iam_role_prefix.is_create_iam_role ? 1 : 0
  role       = aws_iam_role.events[0].name
  policy_arn = aws_iam_policy.events[0].arn
}


# CloudWatch Log Group for Lambda
resource "aws_cloudwatch_log_group" "rds_stop" {
  name              = "/aws/lambda/${local.lambda_function_name}"
  retention_in_days = var.cwl_retention_indays

  tags = {
    Name = format("%s-%s-log-group-lambda-rdsStop-%02d", var.pj_tags.name, var.pj_tags.env, 1)
    PJ   = var.pj_tags.name
    Env  = var.pj_tags.env
  }
}

##############################
# Lambda
##############################

data "archive_file" "function" {
  type        = "zip"
  source_file = "${path.module}/function/lambda_function.py"
  output_path = "${path.module}/function/lambda_function.zip"
}

resource "aws_lambda_function" "rds_stop" {
  filename         = data.archive_file.function.output_path
  source_code_hash = data.archive_file.function.output_base64sha256
  function_name    = local.lambda_function_name
  role             = var.iam_role_prefix.is_create_iam_role ? aws_iam_role.lambda[0].arn : var.iam_role_prefix.existing_lambda_role_arn
  handler          = "lambda_function.lambda_handler" # Replace with your handler function
  runtime          = "python3.12"                     # Choose your desired runtime

  timeout     = 30
  memory_size = 128

  logging_config {
    log_format = "Text"
  }

  environment {
    variables = {
      EXCLUDE_TAG_KEY   = var.lambda_env_variables.exclude_tag_key
      EXCLUDE_TAG_VALUE = var.lambda_env_variables.exclude_tag_value
    }
  }

  tags = {
    Name = local.lambda_function_name
    PJ   = var.pj_tags.name
    Env  = var.pj_tags.env
  }

  depends_on = [
    aws_cloudwatch_log_group.rds_stop,
    aws_iam_role.lambda[0],
  ]
}


##############################
# EventBridge (CloudWatch Events) Rule
##############################
resource "aws_cloudwatch_event_rule" "schedule" {
  name                = format("%s-%s-event-rule-rdsStop-%02d", var.pj_tags.name, var.pj_tags.env, 1)
  description         = "Schedule for RDS stop Lambda function"
  schedule_expression = var.events_prefix.schedule_expression

  tags = {
    Name = format("%s-%s-event-rule-rdsStop-%02d", var.pj_tags.name, var.pj_tags.env, 1)
    PJ   = var.pj_tags.name
    Env  = var.pj_tags.env
  }
}

##############################
# EventBridge Target
##############################
resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.schedule.name
  target_id = "LambdaFunction"
  arn       = aws_lambda_function.rds_stop.arn
  role_arn  = var.iam_role_prefix.is_create_iam_role ? aws_iam_role.events[0].arn : var.iam_role_prefix.existing_events_role_arn
}

##############################
# Lambda permission to allow EventBridge to invoke the function
##############################
resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowEventBridgeInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.rds_stop.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.schedule.arn
}
