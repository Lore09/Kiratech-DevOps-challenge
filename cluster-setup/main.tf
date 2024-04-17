provider "kubernetes" {
  config_path    = "k3s.yaml"
  config_context = "default"
  insecure = true
}

resource "kubernetes_namespace" "kiratech-ns" {
  metadata {
    name = "kiratech-test"
  }
}