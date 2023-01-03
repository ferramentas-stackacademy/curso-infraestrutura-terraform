resource "google_bigquery_dataset" "dataset_trip" {
  dataset_id    = "dataset_trip"
  friendly_name = "dataset_trip"
  description   = "Data Plataform - stack data processing SFTP"
  location      = var.location
  project = var.project
}

resource "google_bigquery_table" "trip_table_native" {
  dataset_id  = google_bigquery_dataset.dataset_trip.dataset_id
  table_id    = "${var.prefix}_trip_table"
  description = "Tabela com dados consolidados appsflyer installs"
  deletion_protection=false 
  project = var.project
}

######## TRANSFERÊNCIA DE DADOS #######
resource "google_bigquery_data_transfer_config" "transfer_dataset_trip" {
  display_name           = "${var.prefix}_transfer_dataset_trip"
  project = var.project
  location               = var.location
  data_source_id         = "google_cloud_storage"
  schedule               = "every day 13:00"
  destination_dataset_id = google_bigquery_dataset.dataset_trip.dataset_id
  params = {
    data_path_template              = "gs://terraform-course-stack-curated-layer-production/fhvhv_tripdata_2022-04.parquet"
    destination_table_name_template = google_bigquery_table.trip_table_native.table_id
    file_format                     = "PARQUET"
    write_disposition               = "MIRROR"
  }
}