provider "google" {
  project = var.google_cloud_project_id
  region  = var.google_cloud_region
  zone    = var.google_cloud_zone
}

// Fetch latest image of GKE node image
// https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/container_engine_versions
data "google_container_engine_versions" "gke_version" {
  location       = var.google_cloud_region
  version_prefix = "1.30."
}

// Resource for GKE
resource "google_compute_network" "vpc" {
  name                    = "${var.gke_network_prefix}-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  region        = var.google_cloud_region
  name          = "${var.gke_network_prefix}-subnet"
  network       = google_compute_network.vpc.name
  ip_cidr_range = var.gke_subnet_cidr
}

resource "google_container_cluster" "primary" {
  location = var.google_cloud_region
  name     = var.gke_cluster_name
  // Since GKE will create node-pool by default during cluster creation,
  // removed and configure multiple node-pool
  remove_default_node_pool = true
  initial_node_count       = 1
  network                  = google_compute_network.vpc.name
  subnetwork               = google_compute_subnetwork.subnet.name
}

resource "google_container_node_pool" "primary_nodes" {
  name     = google_container_cluster.primary.name
  location = var.google_cloud_region
  cluster  = google_container_cluster.primary.name

  // 1.30.x defined in "data" block
  version = data.google_container_engine_versions.gke_version.release_channel_latest_version["STABLE"]
  // Node counts in each Node Pool
  // default: 1 (in ./variables.tf) -> 3 nodes GKE Cluster
  node_count = var.gke_num_nodes

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
    labels = {
      env = var.google_cloud_project_id
    }
    # preemptible  = true
    machine_type = "n1-standard-1"
    tags         = ["gke-node", "${var.google_cloud_project_id}-gke"]
    metadata = {
      disable-legacy-endpoints = true
    }
  }
}
