// Configurations for using TFC(HCP Terraform)
terraform {
  cloud {
    organization = "hwakabh-test"
    workspaces {
      name = "setup-google-cloud"
    }
  }
}

// Provider Configurations
provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

// Fetch latest image of GKE node image
// https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/container_engine_versions
data "google_container_engine_versions" "gke_version" {
  location = var.region
  version_prefix = "1.30."
}


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
  // default: 2 (in ./terraform.tfvars)
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
