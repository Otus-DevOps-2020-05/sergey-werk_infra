output "external_ip_addr_app" {
  value = {
    for instance in yandex_compute_instance.app :
    instance.name => instance.network_interface.0.nat_ip_address
  }
}
