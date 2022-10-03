variable "github_owner" {
  type        = string
  description = "github owner"
}

variable "repository_name" {
  type        = string
  default     = "test-provider"
  description = "github repository name"
}

variable "target_path" {
  type        = string
  default     = "staging-cluster"
  description = "flux sync target path"
}