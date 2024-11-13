variable "container_registry_url" {
  type        = string
  description = "Container registry URL to push container images"
}

variable "container_registry_username" {
  type        = string
  description = "Username for pushing images to container registry"
}

variable "container_registry_password" {
  type        = string
  description = "GitHub PAT for pushing images to ghcr.io"
}
