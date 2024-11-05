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
resource "helm_release" "vault_ent" {
  name        = "vault-ent"
  // https://github.com/hashicorp/vault-helm
  repository  = "https://helm.releases.hashicorp.com"
  chart       = "vault"

  // Values Overrides
  // https://github.com/hashicorp/vault-helm/blob/main/values.yaml
  set {
    name = "global.namespace"
    value = "vault"
  }
  set {
    name = "server.image.repository"
    value = "hashicorp/vault-enterprise"
  }
  set {
    name = "server.image.tag"
    value = "1.17.7-ent"
  }
  set {
    name = "server.image.pullPolicy"
    value = "Always"
  }
  set {
    name = "server.enterpriseLicense.secretKey"
    value = "${var.vault_ent_license_value}"
  }
  set {
    // https://developer.hashicorp.com/vault/docs/platform/k8s/helm/enterprise
    name = "server.enterpriseLicense.secretName"
    value = "vault-ent-license"
  }

  set {
    name = "server.ingress.enabled"
    value = "true"
  }

}
