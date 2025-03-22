<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | n/a |
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_event_rule.schedule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule) | resource |
| [aws_cloudwatch_event_target.lambda_target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target) | resource |
| [aws_cloudwatch_log_group.rds_stop](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_iam_policy.events](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.rds_stop](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.events](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.events](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.lambda_execute](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.rds_stop](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_lambda_function.rds_stop](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_permission.allow_eventbridge](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [archive_file.function](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [aws_iam_policy_document.events_assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.lambda_assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.lambda_invoke](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.rds_stop](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cwl_retention_indays"></a> [cwl\_retention\_indays](#input\_cwl\_retention\_indays) | n/a | `number` | `30` | no |
| <a name="input_events_prefix"></a> [events\_prefix](#input\_events\_prefix) | n/a | <pre>object({<br/>    schedule_expression = optional(string, "cron(0 18 ? * * *)")<br/>  })</pre> | n/a | yes |
| <a name="input_iam_role_prefix"></a> [iam\_role\_prefix](#input\_iam\_role\_prefix) | n/a | <pre>object({<br/>    is_create_iam_role       = optional(bool, false)<br/>    existing_lambda_role_arn = optional(string, null)<br/>  })</pre> | n/a | yes |
| <a name="input_lambda_env_variables"></a> [lambda\_env\_variables](#input\_lambda\_env\_variables) | n/a | <pre>object({<br/>    exclude_tag_key   = optional(string, "Env")<br/>    exclude_tag_value = optional(string, "prd")<br/>  })</pre> | n/a | yes |
| <a name="input_pj_tags"></a> [pj\_tags](#input\_pj\_tags) | n/a | <pre>object({<br/>    name = string<br/>    env  = string<br/>  })</pre> | <pre>{<br/>  "env": "test",<br/>  "name": "hoge"<br/>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cwl_arn"></a> [cwl\_arn](#output\_cwl\_arn) | n/a |
| <a name="output_events_id"></a> [events\_id](#output\_events\_id) | n/a |
| <a name="output_lambda_arn"></a> [lambda\_arn](#output\_lambda\_arn) | n/a |
| <a name="output_lambda_code_sha256"></a> [lambda\_code\_sha256](#output\_lambda\_code\_sha256) | n/a |
<!-- END_TF_DOCS -->