
##############################################################
################ CRIAR VM PARA RODAR AIRBYTE #################
##############################################################

########## Terraform com GCP ##########

# Schedule Policy - agendamento snapshot VMs
resource "google_compute_resource_policy" "schedule01" {
  name        = "snapshot-schedule01"
  project     = var.project
  description = "Snapshot backup VM"
  region      = var.region
  snapshot_schedule_policy {
    schedule {
      weekly_schedule {
        day_of_weeks {
          day = "SUNDAY"
          # Horario padrao UTC
          start_time = "01:00"
        }
      }
    }
    # retencao snapshot
    retention_policy {
      max_retention_days    = 14
      on_source_disk_delete = "KEEP_AUTO_SNAPSHOTS"
    }
    snapshot_properties {
      labels = {
        snapshot = "vm"
      }
      storage_locations = [var.location]
      guest_flush       = false
    }
  }
}


# Reservar ip publico para vm
resource "google_compute_address" "static1" {
  name = "ipv4-address-airbyte"
  project = var.project
}

# Criar vm - Compute Engine
resource "google_compute_instance" "vm-airbyte-prd" {
  name         = "${var.prefix}-vm-airbyte"
  machine_type = "n1-standard-2"
  zone         = var.zone
  project = var.project

  # TAG
  tags = ["airbyte"]

  # Imagem a ser instalada
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10"

    }
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral public IP
      # Reserver ip publico
      nat_ip = google_compute_address.static1.address
    }
  }

  metadata = {
    airbyte = "prd"
    # Adiciona chave para acesso SSH
    ssh-keys = "stackuserterraform:${file("ssh_key.pub")}"
  }
}

# criar regra de firewall para acesso https
resource "google_compute_firewall" "allow-airbyte-https" {
  name    = "allow-airbyte-https"
  network = "default"
  project = var.project

  allow {
    protocol = "tcp"
    ports    = ["8000"]
  }

  // Allow traffic
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["airbyte"]
  priority      = "65534"
}

# Adicionar schedule snapshot boot_disk
resource "google_compute_disk_resource_policy_attachment" "attachment1" {
  name = google_compute_resource_policy.schedule01.name
  disk = google_compute_instance.vm-airbyte-prd.name
  zone = var.zone
  project = var.project
}