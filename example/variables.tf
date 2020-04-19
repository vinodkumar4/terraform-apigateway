variable "region" {
  description = "Chose a region to create required resources. For example us-east-1, eu-central-1 etc."
  type        = "string"
}

variable "profile" {
  type        = "string"
  description = "Please chose a valid profile to communicate to AWS provider."
}
