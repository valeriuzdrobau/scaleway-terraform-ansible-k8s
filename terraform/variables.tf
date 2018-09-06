variable "organisation_id" {}
variable "secret_token" {}
variable "region" {
  default = "par1"
}

# provider "aws" {
#   access_key = "${var.access_key}"
#   secret_key = "${var.secret_key}"
#   region     = "${var.region}"
# }