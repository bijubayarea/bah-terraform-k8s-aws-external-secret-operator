#######

variable "region" {
  description = "AWS Region"
  type        = string
  default     = "us-west-2"
}


# secret variable : db_username
variable "db_username" {
  description = "DB username"
  type        = string
}



# environment
variable "environment" {
  description = "environment"
  type        = string
  default     = "staging"
}



variable "app_namespace" {
  description = "Name of Kubernetes application namespace"
  type        = string
  default     = "database"
}
