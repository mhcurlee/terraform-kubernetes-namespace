
terraform {
  required_version = "~> 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.11.0"
    }
  }
}



provider "kubernetes" {
  host                   = var.host
  cluster_ca_certificate = var.cacert
  token                  = var.token

}


// Create Name space

resource "kubernetes_namespace" "namespace" {
  metadata {
    annotations = {
      name = "example-annotation"
    }

    labels = {
      mylabel = "label-value"
    }

    name = var.namespace_name
  }
}


// Add quota

resource "kubernetes_resource_quota" "quota" {
  metadata {
    name      = "terraform-example"
    namespace = kubernetes_namespace.namespace.id
  }
  spec {
    hard = {
      "pods"                   = var.max_pods
      "limits.cpu"             = var.cpu_limit
      "limits.memory"          = var.memory_limit
      "requests.cpu"           = var.cpu_request
      "requests.memory"       = var.memory_request
      "services.loadbalancers" = 0
    }

  }
}


// Add limitRange

resource "kubernetes_limit_range" "limitrange" {
  metadata {
    name      = "terraform-example"
    namespace = kubernetes_namespace.namespace.id
  }
  spec {
    limit {
      type = "Container"
      default = {
        cpu    = "100m"
        memory = "100Mi"
      }
    }
  }
}


// Add Role binding

resource "kubernetes_role_binding" "rolebinding" {
  metadata {
    name      = "default"
    namespace = kubernetes_namespace.namespace.id
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = "admin"
  }
  subject {
    kind      = "User"
    name      = "dev-user"
    api_group = "rbac.authorization.k8s.io"
  }
}


// Add PSP

resource "kubernetes_pod_security_policy" "psp" {
  metadata {
    name = "${kubernetes_namespace.namespace.id}-psp"
  }
  spec {
    privileged                 = false
    allow_privilege_escalation = false

    volumes = [
      "configMap",
      "emptyDir",
      "projected",
      "secret",
      "downwardAPI",
      "persistentVolumeClaim",
    ]

    run_as_user {
      rule = "MustRunAsNonRoot"
    }

    se_linux {
      rule = "RunAsAny"
    }


    supplemental_groups {
      rule = "MustRunAs"
      range {
        min = 1
        max = 65535
      }
    }

    fs_group {
      rule = "MustRunAs"
      range {
        min = 1
        max = 65535
      }
    }

    read_only_root_filesystem = true
  }
}

resource "kubernetes_cluster_role" "psp_clusterrole" {
  metadata {
    name = "${kubernetes_namespace.namespace.id}-psp-clusterrole"
  }

  rule {
    api_groups     = ["policy"]
    resources      = ["podsecuritypolicies"]
    resource_names = [kubernetes_pod_security_policy.psp.id]
    verbs          = ["use"]
  }
}

resource "kubernetes_cluster_role_binding" "psp_clusterrolebinding" {
  metadata {
    name = "${kubernetes_namespace.namespace.id}-psp-clusterrolebinding"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.psp_clusterrole.id
  }
  subject {
    kind      = "Group"
    name      = "system:serviceaccounts:${kubernetes_namespace.namespace.id}"
    api_group = "rbac.authorization.k8s.io"
  }


}

// add Netpol objects



