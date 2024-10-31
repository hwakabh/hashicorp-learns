// Configurations for using TFC(HCP Terraform)
terraform {
  cloud {
    organization = "hwakabh-test"
    workspaces {
      name = "setup-vault-gke"
    }
  }
}

// Need to update fetch kubeconfig on HCP Terraform
// https://registry.terraform.io/providers/hashicorp/helm/latest/docs
// https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/using_gke_with_terraform#using-the-kubernetes-and-helm-providers
data "google_client_config" "provider" {}

provider "google" {
  project = "hc-8732d2178369440c886cb59aee6"
  region  = "asia-east1"
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
// TODO: Specify version: 1.17.7 (from installed 1.17.2) and add setup configuration with overrides
resource "helm_release" "vault_enterprise" {
  name        = "vault-enterprise"
  // https://github.com/hashicorp/vault-helm
  repository  = "https://helm.releases.hashicorp.com"
  chart       = "vault"
  // Need to create namespace to be installed (by k8s provider or kubectl)
  // before applying plans
  namespace   = "vault"

  // Values Overrides
  // https://github.com/hashicorp/vault-helm/blob/main/values.yaml
  set {
    name = "server.ingress.enabled"
    value = "true"
  }
}
