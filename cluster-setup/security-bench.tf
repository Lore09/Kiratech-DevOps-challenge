resource "kubernetes_job" "security_benchmark" {

  metadata {
    name = "security-benchmark"
    namespace = kubernetes_namespace.kiratech-ns.metadata.0.name
  }

  spec {
    template {
      metadata {
        labels = {
          app = "security-benchmark"
        }
      }

      spec {
        container {

          image = "docker.io/aquasec/kube-bench:v0.7.2"
          name  = "kube-bench"
          command = [ "kube-bench" ]

          volume_mount {
            name = "var-lib-kubelet"
            mount_path = "/var/lib/kubelet"
            read_only = true
          }

          volume_mount {
            name = "var-lib-cni"
            mount_path = "/var/lib/cni"
            read_only = true
          }

          volume_mount {
            name = "var-lib-etcd"
            mount_path = "/var/lib/etcd"
            read_only = true
          }

          volume_mount {
            name = "var-lib-kube-scheduler"
            mount_path = "/var/lib/kube-scheduler"
            read_only = true
          }

          volume_mount {
            name = "var-lib-kube-controller-manager"
            mount_path = "/var/lib/kube-controller-manager"
            read_only = true
          }

          volume_mount {
            name = "etc-systemd"
            mount_path = "/etc/systemd"
            read_only = true
          }

          volume_mount {
            name = "lib-systemd"
            mount_path = "/lib/systemd"
            read_only = true
          }

          volume_mount {
            name = "srv-kubernetes"
            mount_path = "/srv/kubernetes"
            read_only = true
          }

          volume_mount {
            name = "etc-kubernetes"
            mount_path = "/etc/kubernetes"
            read_only = true
          }

          volume_mount {
            name = "usr-bin"
            mount_path = "/usr/local/mout-from-host/bin"
            read_only = true
          }

          volume_mount {
            name = "etc-cni-netd"
            mount_path = "/etc/cni/net.d"
            read_only = true
          }
          
          volume_mount {
            name = "etc-cni-bin"
            mount_path = "/opt/cni/bin"
            read_only = true
          }

        }

        host_pid = true
        restart_policy = "Never"

        volume {
          name = "var-lib-cni"
          host_path {
            path = "/var/lib/cni"
          }
        }

        volume {
          name = "var-lib-etcd"
          host_path {
            path = "/var/lib/etcd"
          }
        }

        volume {
          name = "var-lib-kubelet"
          host_path {
            path = "/var/lib/kubelet"
          }
        }

        volume {
          name = "var-lib-kube-scheduler"
          host_path {
            path = "/var/lib/kube-scheduler"
          }
        }

        volume {
          name = "var-lib-kube-controller-manager"
          host_path {
            path = "/var/lib/kube-controller-manager"
          }
        }

        volume {
          name = "etc-systemd"
          host_path {
            path = "/etc/systemd"
          }
        }

        volume {
          name = "lib-systemd"
          host_path {
            path = "/lib/systemd"
          }
        }

        volume {
          name = "srv-kubernetes"
          host_path {
            path = "/srv/kubernetes"
          }
        }

        volume {
          name = "etc-kubernetes"
          host_path {
            path = "/etc/kubernetes"
          }
        }

        volume {
          name = "usr-bin"
          host_path {
            path = "/usr/bin"
          }
        }

        volume {
          name = "etc-cni-netd"
          host_path {
            path = "/etc/cni/net.d"
          }
        }

        volume {
          name = "etc-cni-bin"
          host_path {
            path = "/opt/cni/bin"
          }
        }

      }
    }
  }
}