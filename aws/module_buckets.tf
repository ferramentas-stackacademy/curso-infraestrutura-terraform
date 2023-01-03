module "buckets" {
  
  source = "./dir_module_buckets"

  bucket_names = ["stack-terraform13","stack-terraform14","stack-terraform15","stack-terraform16"]
  project_name = "data-platform"
  db_password = "Stack2022!"
  db_username = "admin"
  environment = "prod"

}