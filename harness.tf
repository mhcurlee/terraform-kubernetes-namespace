// Harness SA



resource "kubernetes_service_account" "harness" {
  metadata {
    name      = "harness"
    namespace = kubernetes_namespace.namespace.id
  }

}

resource "kubernetes_role_binding" "harness_rb" {
  metadata {
    name      = "harness-rb"
    namespace = kubernetes_namespace.namespace.id
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "edit"
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.harness.metadata.name
    namespace = kubernetes_namespace.namespace.id
  }
}