
output "ext_ip_addr_app" {
  value = {
    for instance in yandex_compute_instance.app :
    instance.name => instance.network_interface.0.nat_ip_address
  }
}

output "lb_ip_addr" {
  value = [for l in yandex_lb_network_load_balancer.app_lb.listener : l.external_address_spec.*.address].0
}
