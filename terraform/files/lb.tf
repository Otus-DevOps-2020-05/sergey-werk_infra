resource "yandex_lb_target_group" "app_lb_group" {
  name = "app-lb-group"

  # A piece of beauty of declarative languages... Damn it!

  dynamic "target" {
    for_each = [for app in yandex_compute_instance.app : {
      subnet_id = app.network_interface.0.subnet_id
      address   = app.network_interface.0.ip_address
    }]

    content {
      subnet_id = target.value.subnet_id
      address   = target.value.address
    }
  }
}

resource "yandex_lb_network_load_balancer" "app_lb" {

  name = "app-lb"

  listener {
    name        = "proto-app"
    port        = "9292"
    target_port = "9292"

    external_address_spec {
      # Important! Without it fails with error "Only one address field is allowed".
      # Two hours wasted here ]:E
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = yandex_lb_target_group.app_lb_group.id
    healthcheck {
      name = "hc-app"
      http_options {
        port = "9292"
        path = "/"
      }
    }
  }
}
