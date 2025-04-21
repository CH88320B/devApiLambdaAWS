# Crear el rol de ejecución de Lambda
resource "aws_iam_role" "lambda_exec" {
  name = "lambda_exec_role_webapipolizas"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

# Permiso básico de logs para Lambda
resource "aws_iam_role_policy_attachment" "lambda_exec_attach" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Crear la función Lambda
resource "aws_lambda_function" "webapipolizas" {
  function_name = "${var.lambda_function_name}-${local.environment}"
  filename      = "./lambda/WebApiPolizas.zip"
  handler       = "WebApiPolizas::WebApiPolizas.LambdaEntryPoint::FunctionHandlerAsync"
  runtime       = "dotnet8"
  memory_size   = 512
  timeout       = 30
  role          = aws_iam_role.lambda_exec.arn
  source_code_hash = filebase64sha256("./lambda/WebApiPolizas.zip")
}

# Crear el API Gateway HTTP
resource "aws_apigatewayv2_api" "webapipolizas_api" {
  name          = "${var.api_gateway_name}-${local.environment}"
  protocol_type = "HTTP"
}

# Integrar el API Gateway con la Lambda
resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id           = aws_apigatewayv2_api.webapipolizas_api.id
  integration_type = "AWS_PROXY"
  integration_uri  = aws_lambda_function.webapipolizas.invoke_arn
}

# Crear la ruta /{proxy+} para capturar todas las rutas de la API
resource "aws_apigatewayv2_route" "lambda_route" {
  api_id    = aws_apigatewayv2_api.webapipolizas_api.id
  route_key = "ANY /{proxy+}"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

# Crear el Stage para el API Gateway
resource "aws_apigatewayv2_stage" "default_stage" {
  api_id      = aws_apigatewayv2_api.webapipolizas_api.id
  name        = "$default"
  auto_deploy = true
}

# Permitir que API Gateway invoque la Lambda
resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.webapipolizas.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.webapipolizas_api.execution_arn}/*/*"
}
