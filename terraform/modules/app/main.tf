locals {
  timestamp = formatdate("YYYYMMDDhhmmss", timestamp())
}

resource "yandex_compute_instance" "app" {
  count = var.initial_count
  name  = "reddit-app${count.index + 1}-${local.timestamp}"
  labels = {
    tags = "reddit-app"
  }

  metadata = {
    ssh-keys = "ubuntu:${file(var.public_key_path)}"
  }

  resources {
    cores         = 2
    memory        = 2
    core_fraction = 100
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
    }
  }

  network_interface {
    subnet_id = var.subnet_id
    nat       = true
  }

  connection {
    type        = "ssh"
    host        = self.network_interface.0.nat_ip_address
    user        = "ubuntu"
    agent       = false
    private_key = file(var.private_key_path)
  }

  lifecycle {
    create_before_destroy = true
  }
}
