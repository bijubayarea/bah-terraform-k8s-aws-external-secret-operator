resource "kubernetes_namespace" "app_namespace" {
  metadata {

    labels = {
      name = var.app_namespace
    }

    name = var.app_namespace
  }
}

# deploy sample pod including k8s secret creared by ESO
resource "kubectl_manifest" "app_sample_pod" {
  depends_on = [kubectl_manifest.external_secret]

  yaml_body = file("${path.module}/k8s/k8s-app-sample-pod.yaml")
}