terraform {
  backend "gcs" {
    bucket      = "backend-terraform-course-19122022"
    prefix      = "terraform/state"
    credentials = "stack-terraform-user.json"
  }
}