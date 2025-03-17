variable "pj_tags" {
  type = object({
    name = string
    env  = string
  })
  default = {
    name = "hoge"
    env  = "test"
  }
}


variable "iam_role_prefix" {
  type = object({
    is_create_iam_role       = optional(bool, false)
    existing_lambda_role_arn = optional(string, null)
    existing_events_role_arn = optional(string, null)
  })
}

variable "cwl_retention_indays" {
  type    = number
  default = 30
}

variable "lambda_env_variables" {
  type = object({
    exclude_tag_key   = optional(string, "Env")
    exclude_tag_value = optional(string, "prd")
  })
}

variable "events_prefix" {
  type = object({
    schedule_expression = optional(string, "cron(0 18 ? * * *)")
  })

}
