variable "client_id" {
  description = "Client ID for the service principal associated with the cluster."
  type        = string
}

variable "client_secret" {
  description = "Client Secret for the service principal associated with the cluster."
  type        = string

}

variable "subscription_id" {
  description = "Current subcription id."
  type        = string
}

variable "tenant_id" {
  description = "Current tenant id."
  type        = string
}
