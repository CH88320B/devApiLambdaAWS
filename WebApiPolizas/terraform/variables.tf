variable "lambda_function_name" {
  description = "Nombre base de la Lambda"
  type        = string
  default     = "WebApiPolizas"
}

variable "api_gateway_name" {
  description = "Nombre base del API Gateway"
  type        = string
  default     = "WebApiPolizasAPI"
}
locals {
  environment = terraform.workspace
}
