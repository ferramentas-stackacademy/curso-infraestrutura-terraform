variable "region" {
  description = "gcs region"
}

variable "zone" {
  description = "gcs zone"
}

variable "location" {
  description = "gcs region"
}

variable "environment" {
  description = "environment to be implemented"
}

variable "prefix" {
  description = "objects prefix"
}

variable "project" {
  description = "project name"
}

variable "project_id" {
  description = "project id"
}

variable "storage_class_standard" {
  description = "gsc stoge class standard"
  type        = string
}

variable "storage_class_nearline" {
  description = "gsc stoge class nearline"
  type        = string
}

variable "storage_class_coldline" {
  description = "gsc stoge class coldline"
  type        = string
}

variable "storage_class_archive" {
  description = "gsc stoge class archive"
  type        = string
}

variable "bucket_names" {
  description = "gsc bucket names"
  type        = list(string)
}

variable "members" {
  description = "members authorizaded"
  type        = list(string)
}