###############################################
## Create user to access AWS secrets manager ##
###############################################

# Create IAM user for reading aws_secret_manager
resource "aws_iam_user" "secrets_reader" {
  name = "secrets-reader"
  path = "/"
}

# access key for secrets-reader
resource "aws_iam_access_key" "secrets_reader_key" {
  user = aws_iam_user.secrets_reader.name
}

# create IAM group for user=secrets_reader
resource "aws_iam_group" "secrets_reader_group" {
  name = "secrets-reader-group"
  path = "/"
}

# Associate user=secrets_reader to secrets_reader_group
resource "aws_iam_user_group_membership" "secrets_reader_memebership" {
  user = aws_iam_user.secrets_reader.name

  groups = [
    aws_iam_group.secrets_reader_group.name
  ]
}



# IAM policy document  for secrets_reader to read AWS secrets manager
data "aws_iam_policy_document" "secrets_reader_policy_document" {
  depends_on = [aws_secretsmanager_secret_version.db_credentials_version]

  statement {

    actions = ["secretsmanager:ListSecrets",
               "secretsmanager:GetSecretValue"]
    effect = "Allow"
    #resources  =  ["aws_secretsmanager_secret_version.db_credentials.arn"]
    resources = ["${data.aws_secretsmanager_secret_version.db_credentials_version.secret_id}"]

  }

}


# S3 read policy for S3 bucket
resource "aws_iam_policy" "secrets_reader_policy" {

  name   = "secrets_reader_policy"
  path   = "/"
  policy = data.aws_iam_policy_document.secrets_reader_policy_document.json
}

# Attach s3_user_group to assume_s3_owner Read role
resource "aws_iam_group_policy_attachment" "secrets_reader_attach" {
  group      = aws_iam_group.secrets_reader_group.name
  policy_arn = aws_iam_policy.secrets_reader_policy.arn
}


# Write IAM user Key to file. only for testing/verification, not for production
resource "local_file" "iam_user_access_key" {
  depends_on = [aws_iam_group_policy_attachment.secrets_reader_attach]

  content  = "${aws_iam_access_key.secrets_reader_key.id}"
  filename = "${path.cwd}/iam_access_key.txt"
}

# Write IAM user secret to file. only for testing/verification, not for production
resource "local_file" "iam_user_access_secret" {
  depends_on = [local_file.iam_user_access_key]
  
  content  = "${aws_iam_access_key.secrets_reader_key.secret}"
  filename = "${path.cwd}/iam_access_secret.txt"
}
