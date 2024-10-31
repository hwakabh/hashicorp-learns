// Configurations for using TFC(HCP Terraform)
terraform {
  cloud {
    organization = "hwakabh-test"
    workspaces {
      name = "setup-vault-gke"
    }
  }
}

// TODO: need to update fetch kubeconfig on HCP Terraform
// https://registry.terraform.io/providers/hashicorp/helm/latest/docs
provider "helm" {
    kubernetes {
        config_path = "~/.kube/config"
        config_context = "gke_hc-8732d2178369440c886cb59aee6_asia-east1_tf-gke-cluster"
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
