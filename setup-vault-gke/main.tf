// Need to update fetch kubeconfig on HCP Terraform
// https://registry.terraform.io/providers/hashicorp/helm/latest/docs
// https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/using_gke_with_terraform#using-the-kubernetes-and-helm-providers
data "google_client_config" "provider" {}

provider "google" {
  project = "${var.google_cloud_project_id}"
  region  = "${var.google_cloud_region}"
}

data "google_container_cluster" "my_cluster" {
  name     = "${var.gke_cluster_name}"
  location = "${var.google_cloud_region}"
}

provider "helm" {
    kubernetes {
        host  = "https://${data.google_container_cluster.my_cluster.endpoint}"
        token = data.google_client_config.provider.access_token
        cluster_ca_certificate = base64decode(
          data.google_container_cluster.my_cluster.master_auth[0].cluster_ca_certificate,
        )
        exec {
            api_version = "client.authentication.k8s.io/v1beta1"
            command     = "gke-gcloud-auth-plugin"
        }
    }
}

// https://github.com/hashicorp/vault-helm
resource "helm_release" "vault_primary_cluster" {
  name              = "vault-ha"
  repository        = "https://helm.releases.hashicorp.com"
  chart             = "vault"
  namespace         = "vault"
  create_namespace  = true

  // Values Overrides
  // https://github.com/hashicorp/vault-helm/blob/main/values.yaml
  // https://developer.hashicorp.com/vault/docs/platform/k8s/helm/terraform
  set {
    name = "global.namespace"
    value = "vault"
  }
  // Vault enterprise
  // Ref: https://developer.hashicorp.com/vault/docs/platform/k8s/helm/enterprise
  // for server.enterpriseLicense.secretKey, we can use default `license` as described
  set {
    name = "server.enterpriseLicense.secretName"
    value = "vault-ent-license"
  }
  set {
    name = "server.image.repository"
    value = "hashicorp/vault-enterprise"
  }
  set {
    name = "server.image.tag"
    value = "1.17.7-ent"
  }
  // ingress
  set {
    name = "server.ingress.enabled"
    value = "true"
  }
  set {
    name = "server.ingress.annotations"
    value = yamlencode({
      "kubernetes.io/ingress.class": "gce"
    })
    type = "auto"
  }
  set {
    name  = "server.ingress.hosts[0].host"
    value = "vault.hc-8b1ddb1733494af2af02d477176.gcp.sbx.hashicorpdemo.com."
  }
  // Vault cluster
  set {
    name = "server.standalone.enabled"
    value = "false"
  }
  set {
    name = "server.ha.enabled"
    value = "true"
  }
  set {
    name = "server.ha.replicas"
    value = 3
  }
  set {
    name = "server.ha.raft.enabled"
    value = "true"
  }
  set {
    name = "server.ha.raft.setNodeId"
    value = "true"
  }
  set {
    name = "server.ha.raft.config"
    value = <<EOF
ui = true
cluster_name = "vault-cluster"
listener "tcp" {
  tls_disable = true
  address = "[::]:8200"
  cluster_address = "[::]:8201"
}
seal "gcpckms" {
    credentials = "/vault/userconfig/vault-kms-credentials/vault-unseal.key.json"
    project     = "hc-8b1ddb1733494af2af02d477176"
    region      = "global"
    key_ring    = "vault-ent-cloudkeys"
    crypto_key  = "vault-crypto-key"
}
storage "raft" {
  path = "/vault/data"
  retry_join {
    leader_api_addr = "http://vault-ha-0.vault-ha-internal:8200"
  }
  retry_join {
    leader_api_addr = "http://vault-ha-1.vault-ha-internal:8200"
  }
  retry_join {
    leader_api_addr = "http://vault-ha-2.vault-ha-internal:8200"
  }
}
service_registration "kubernetes" {}
EOF
  }

  // Passing another dedicated service-account credentials for avoidings `GOOGLE_CREDENTIALS`
  // whereas service-account for TFC will use DPC
  // Ref: https://developer.hashicorp.com/vault/docs/platform/k8s/helm/run#protecting-sensitive-vault-configurations
  set {
    name  = "server.volumes[0].name"
    value = "vault-kms-credentials"
  }
  set {
    name  = "server.volumes[0].secret.defaultMode"
    value = "420"
  }
  set {
    name  = "server.volumes[0].secret.secretName"
    value = "vault-kms-credentials"
  }

  set {
    name  = "server.volumeMounts[0].mountPath"
    value = "/vault/userconfig/vault-kms-credentials"
  }
  set {
    name  = "server.volumeMounts[0].name"
    value = "vault-kms-credentials"
  }
  set {
    name  = "server.volumeMounts[0].readOnly"
    value = "true"
  }
  set {
    name = "server.extraArgs"
    value = "-config=/vault/userconfig/vault-kms-credentials/vault-unseal.key.json"
  }
}
