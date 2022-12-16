# Creating a AWS Secret for db_username and db_password
resource "aws_secretsmanager_secret" "db_credentials_secret" {
  name                    = "db-credentials-secret"
  description             = "Secret for the DB"
  recovery_window_in_days = 0
  tags = {
    Name        = "db-credentials-secret"
    Environment = var.environment
  }
}

# random password is auto sensitive
resource "random_password" "db_password" {
  length  = 16
  special = true
  numeric = true
  upper   = true
  lower   = true
}


resource "aws_secretsmanager_secret_version" "db_credentials_version" {
  secret_id = aws_secretsmanager_secret.db_credentials_secret.id
  #secret_string = var.db_username
  secret_string = <<EOF
   {
    "username": "${var.db_username}",
    "password": "${random_password.db_password.result}"
   }
  EOF
}


# Importing the AWS secrets created previously using arn.
data "aws_secretsmanager_secret" "db_credentials_secret" {
  arn = aws_secretsmanager_secret.db_credentials_secret.arn
}

# Importing the AWS secret version created previously using arn.
data "aws_secretsmanager_secret_version" "db_credentials_version" {
  secret_id = data.aws_secretsmanager_secret.db_credentials_secret.id
}

# After importing the secrets storing into Locals
locals {
  db_creds = jsondecode(data.aws_secretsmanager_secret_version.db_credentials_version.secret_string)
}



# Write secret username/password to file only for testing, not for production
resource "local_file" "secrets_credentials_output" {
  depends_on = [aws_secretsmanager_secret_version.db_credentials_version]

  content  = "username: ${local.db_creds.username}\npassword: ${local.db_creds.password}"
  filename = "${path.cwd}/secrets.txt"
}
