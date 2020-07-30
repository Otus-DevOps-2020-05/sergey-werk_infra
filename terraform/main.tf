provider "yandex" {
  service_account_key_file = var.service_account_key_file
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  zone                     = var.zone
}

data "yandex_compute_image" "db_image" {
  family = "reddit-db"
  folder_id = var.folder_id
}

data "yandex_compute_image" "app_image" {
  family = "reddit-app"
  folder_id = var.folder_id
}


module "app" {
  source          = "./modules/app"
  public_key_path = var.public_key_path
  image_id  	  = data.yandex_compute_image.db_image.id
  subnet_id       = var.subnet_id
  folder_id       = var.folder_id
}

module "db" {
  source          = "./modules/db"
  public_key_path = var.public_key_path
  image_id	  = data.yandex_compute_image.app_image.id
  subnet_id       = var.subnet_id
  folder_id       = var.folder_id
}
