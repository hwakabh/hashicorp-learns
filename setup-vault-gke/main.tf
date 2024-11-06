// Need to update fetch kubeconfig on HCP Terraform
// https://registry.terraform.io/providers/hashicorp/helm/latest/docs
// https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/using_gke_with_terraform#using-the-kubernetes-and-helm-providers
data "google_client_config" "provider" {}

provider "google" {
  project = "hc-8732d2178369440c886cb59aee6"
  region  = "asia-east1"
  // TODO: Need to replace with DPC
  // Passed terraform service-account credentials via GOOGLE_CREDENTIALS
}

data "google_container_cluster" "my_cluster" {
  name     = "tf-gke-cluster"
  location = "asia-east1"
}

provider "helm" {
    kubernetes{
        host  = "https://${data.google_container_cluster.my_cluster.endpoint}"
        token = data.google_client_config.provider.access_token
        cluster_ca_certificate = base64decode(
        data.google_container_cluster.my_cluster.master_auth[0].cluster_ca_certificate,)
        exec {
            api_version = "client.authentication.k8s.io/v1beta1"
            command     = "gke-gcloud-auth-plugin"
        }
    }
}

// Values Overrides
// Ref: https://github.com/hashicorp/vault-helm/blob/main/values.yaml
// For applying Enterprise licenses
// Ref: https://developer.hashicorp.com/vault/docs/platform/k8s/helm/enterprise
// for server.enterpriseLicense.secretKey, we can use default `license` as described
data "template_file" "vault_overrides" {
  template = <<EOF
global:
  namespace: 'vault'
server:
  image:
    repository: 'hashicorp/vault-enterprise'
    tag: '1.17.7-ent'
    pullPolicy: 'Always'
  enterpriseLicense:
    secretName: 'vault-ent-license'
  standalone:
    config: |-
      ui = true
      log_level = "debug"
      listener "tcp" {
        tls_disable = 1
        address = "[::]:8200"
        cluster_address = "[::]:8201"
      }
      storage "file" {
        path = "/vault/data"
      }
      seal "gcpckms" {
         project     = "hc-8732d2178369440c886cb59aee6"
         region      = "global"
         key_ring    = "vault-ent-cloudkeys"
         crypto_key  = "vault-crypto-key"
      }
  ingress:
    enabled: true
EOF
}

resource "helm_release" "vault_ent" {
  name              = "vault-ent"
  // https://github.com/hashicorp/vault-helm
  repository        = "https://helm.releases.hashicorp.com"
  chart             = "vault"
  // Need to create namespace before tf-apply
  namespace         = "vault"
  create_namespace  = true
  values            = "${data.template_file.vault_overrides.rendered}"
}
