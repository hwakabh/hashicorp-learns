provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

// Setup for Dynamic Credentials
# provider "tfe" {
#   hostname = var.tfc_hostname
# }

# data "tfe_project" "tfc_project" {
#   // For fetching data from TFE/TFC, need to generate Token and set as envar
#   name         = var.tfc_project_name
#   organization = var.tfc_organization_name
# }


// Fetch latest image of GKE node image
// https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/container_engine_versions
data "google_container_engine_versions" "gke_version" {
  location = var.region
  version_prefix = "1.30."
}

# // --- Resource for TFC
# // Need not to code in HCL, since already created from UI
# resource "tfe_workspace" "hwakabh-tfworkspace" {
#   name         = var.tfc_workspace_name
#   organization = var.tfc_organization_name
#   project_id   = data.tfe_project.tfc_project.id
# }

# // Adding environmental variables in TFC
# // Required Variables for Dynamic Credentials are:
# // https://developer.hashicorp.com/terraform/cloud-docs/workspaces/dynamic-provider-credentials/gcp-configuration#required-environment-variables
# resource "tfe_variable" "enable_gcp_provider_auth" {
#   workspace_id  = tfe_workspace.hwakabh-tfworkspace.id
#   key           = "TFC_GCP_PROVIDER_AUTH"
#   value         = "true"
#   category      = "env"
#   description   = "Enable the Workload Identity integration for GCP."
# }

# resource "tfe_variable" "tfc_gcp_workload_provider_name" {
#   workspace_id  = tfe_workspace.hwakabh-tfworkspace.id
#   key           = "TFC_GCP_WORKLOAD_PROVIDER_NAME"
#   value         = "tfc-oidc-provider"
#   category      = "env"
#   description   = "The workload provider name to authenticate against."
# }

# resource "tfe_variable" "tfc_gcp_service_account_email" {
#   workspace_id  = tfe_workspace.hwakabh-tfworkspace.id
#   key           = "TFC_GCP_RUN_SERVICE_ACCOUNT_EMAIL"
#   value         = "terraform@hc-8732d2178369440c886cb59aee6.iam.gserviceaccount.com"
#   category      = "env"
#   description   = "The GCP service account email runs will use to authenticate."
# }


// Resource for GKE
resource "google_compute_network" "vpc" {
  name                    = "hwakabh-vpc"
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "subnet" {
  region        = var.region
  name          = "hwakabh-gke-subnet"
  network       = google_compute_network.vpc.name
  ip_cidr_range = "10.10.0.0/24"
}

resource "google_container_cluster" "primary" {
  location = var.region
  name     = "tf-gke-cluster"

  // Since GKE will create node-pool by default during cluster creation,
  // removed and configure multiple node-pool
  remove_default_node_pool = true
  initial_node_count       = 1

  network    = google_compute_network.vpc.name
  subnetwork = google_compute_subnetwork.subnet.name
}

resource "google_container_node_pool" "primary_nodes" {
  name       = google_container_cluster.primary.name
  location   = var.region
  cluster    = google_container_cluster.primary.name

  // 1.30.x defined in "data" block
  version = data.google_container_engine_versions.gke_version.release_channel_latest_version["STABLE"]
  // default: 2 (in ./variables.tf)
  node_count = var.gke_num_nodes

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    labels = {
      env = var.project_id
    }

    # preemptible  = true
    machine_type = "n1-standard-1"
    tags         = ["gke-node", "${var.project_id}-gke"]
    metadata = {
      disable-legacy-endpoints = "true"
    }
  }
}
