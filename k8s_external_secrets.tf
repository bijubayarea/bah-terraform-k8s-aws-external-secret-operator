
resource "kubernetes_namespace" "external_secrets" {
  metadata {

    labels = {
      name = "external-secrets"
    }

    name = "external-secrets"
  }
}


resource "helm_release" "external_secrets" {

  depends_on = [kubernetes_namespace.external_secrets,
                aws_iam_group_policy_attachment.secrets_reader_attach,
                aws_secretsmanager_secret_version.db_credentials_version]

  name       = "external-secrets"
  repository = "https://charts.external-secrets.io"
  chart      = "external-secrets"
  version    = "0.7.0"
  namespace  = "external-secrets"

  set {
    name  = "replicaCount"
    value = "1"
  }

  set {
    name  = "installCRDs"
    value = "true"
  }
 
}

# create k8s CRD ClusterSecretStore to connect to AWS secret Manager
resource "kubectl_manifest" "global-secret-store" {
  depends_on = [helm_release.external_secrets]

  yaml_body = file("${path.module}/k8s/k8s-cluster-secret-store.yaml")
}

# fetch ExternalSecret from AWS secret maanger and create k8s secret
resource "kubectl_manifest" "external_secret" {
  depends_on = [kubectl_manifest.global-secret-store]

  yaml_body = file("${path.module}/k8s/k8s-external-secrets.yaml")
}
