resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_lambda_layer_version" "lambda_layer_pymysql" {
  filename   = "./lambda/python.zip"
  layer_name = "pymysql-v1"
  compatible_runtimes = ["python3.9"]
}

resource "aws_lambda_function" "lambda_get_mysqlsql" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  filename      = "./lambda/app.py.zip"
  function_name = "Lambda_app_Playlists1"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "app.lambda_handler"

  runtime = "python3.9"
  
  layers = [aws_lambda_layer_version.lambda_layer_pymysql.arn]
  
  # get information from rds instance
  environment {
    variables = {
      db_instance_address            = aws_db_instance.rds_mysql_1.address
      db_username                    = aws_db_instance.rds_mysql_1.username
      db_password                    = aws_db_instance.rds_mysql_1.password
      db_port                        = aws_db_instance.rds_mysql_1.port
      db_name                        = aws_db_instance.rds_mysql_1.db_name
    }
  }
}