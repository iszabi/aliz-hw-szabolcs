terraform {
  backend "gcs" {
    credentials = "./terraform-gke-keyfile.json"
    bucket      = "aliz-hw-szabolcs-bucket-1"
    prefix      = "terraform/state"
  }
}

module "kubernetes-engine" {
  source  = "terraform-google-modules/kubernetes-engine/google"
  version = "12.2.0"
  # insert the 9 required variables here
}
