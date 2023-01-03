region                 = "us-central1"
zone                   = "us-central1-c"
location               = "us-central1"
environment            = "production"
prefix                 = "data-plataform"
project                = "stack-terraform-course"
project_id             = "stack-terraform-course"
storage_class_standard = "STANDARD"
storage_class_nearline = "NEARLINE"
storage_class_coldline = "COLDLINE"
storage_class_archive  = "ARCHIVE"
bucket_names           = ["raw-layer", "processing-layer", "curated-layer"]
members = ["serviceAccount:terraform-user@stack-terraform-course.iam.gserviceaccount.com",
           "user:stackuserterraform@gmail.com"]
credentials                  = "stack-terraform-user.json"
name_vm                      = "stack-vm"
machine_type                 = "e2-medium"