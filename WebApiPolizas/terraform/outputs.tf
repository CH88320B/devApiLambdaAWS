output "lambda_function_name" {
  value = aws_lambda_function.webapipolizas.function_name
}

output "api_url" {
  value = aws_apigatewayv2_api.webapipolizas_api.api_endpoint
}
