# create k8s generic secret to be consumed by CRD 'SecretStore'
# to connect to AWS secrets Manager
resource "kubernetes_secret" "awssm-secret" {

    depends_on =    [local_file.iam_user_access_key,
                    local_file.iam_user_access_secret,
                    kubernetes_namespace.app_namespace]

    metadata {
        name      = "awssm-secret"
        namespace = var.app_namespace
    }
    data = {
        "access-key"            = "${aws_iam_access_key.secrets_reader_key.id}"
        "secret-access-key"     = "${aws_iam_access_key.secrets_reader_key.secret}"
    }
    type = "Opaque"
}