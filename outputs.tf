# secrets-reader  AWS_ACCESS_KEY_ID & AWS_SECRET_ACCESS_KEY 
output "secrets_reader_secret_key" {
  value     = aws_iam_access_key.secrets_reader_key.secret
  sensitive = true
}

output "secrets_reader_access_key_id" {
  value = aws_iam_access_key.secrets_reader_key.id
}

output "secrets_reader_arn" {
  value = aws_iam_user.secrets_reader.arn
}

output "db_credentials_arn" {
  description = "DB secret arn"
  #value       = aws_secretsmanager_secret_version.db_credentials.arn
  value = aws_secretsmanager_secret_version.db_credentials_version.arn
}

output "db_username" {
  value     = local.db_creds.username
  sensitive = true
}


output "cluster_name" {
  description = "EKS Cluster Name"
  value       = data.aws_eks_cluster.cluster.name
}

output "oidc_provider_url" {
  description = "oidc provider url"
  #value       =  data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer
  value = replace(data.aws_iam_openid_connect_provider.eks_oidc_provider.url, "https://", "")
}

output "oidc_provider_arn" {
  description = "oidc provider arn"
  value       = data.aws_iam_openid_connect_provider.eks_oidc_provider.arn
}

