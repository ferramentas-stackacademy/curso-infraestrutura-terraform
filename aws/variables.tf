variable "environment" {
    description = "setup the environment"
}

variable "project_name" {
    description = "Nome do projeto"
}

variable "bucket_names" {
    type = list(string)
}

variable "db_username" {
    type = string
}

variable "db_password" {
    type = string
    sensitive = false
}
