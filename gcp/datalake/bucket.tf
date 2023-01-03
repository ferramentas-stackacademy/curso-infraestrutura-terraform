resource "google_storage_bucket" "buckets" {
  count                       = length(var.bucket_names)
  name                        = "${var.project}-${var.prefix}-${var.bucket_names[count.index]}-${var.environment}"
  location                    = var.location
  storage_class               = var.storage_class_standard
  force_destroy               = true
  uniform_bucket_level_access = true
  project = var.project

 # Habilitar versionamento
  versioning {
    enabled = true
  }

  # regra ciclo de vida
  lifecycle_rule {
    condition {
      age = 90
    }
    action {
      type          = "SetStorageClass"
      storage_class = var.storage_class_nearline
    }
  }

  lifecycle_rule {
    condition {
      age = 150
    }
    action {
      type          = "SetStorageClass"
      storage_class = var.storage_class_coldline
    }
  }

  lifecycle_rule {
    condition {
      age = 180
    }
    action {
      type          = "SetStorageClass"
      storage_class = var.storage_class_archive
    }
  }

  # Numero de versoes antigas que ira manter
  lifecycle_rule {
    condition {
      num_newer_versions = 3
    }
    action {
      type = "Delete"
    }
  }
}

##################### POLITICAS DE SEGURANCA ####################
data "google_iam_policy" "admin" {
  binding {
    role    = "roles/storage.admin"
    members = var.members
  }
}

resource "google_storage_bucket_iam_policy" "policy" {
  count       = length(var.bucket_names)
  bucket      = google_storage_bucket.buckets[count.index].name
  policy_data = data.google_iam_policy.admin.policy_data
}
