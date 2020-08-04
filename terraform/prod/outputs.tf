output "external_ip_addresses_app" {
  value = module.app.external_ip_addr_app
}
output "external_ip_address_db" {
  value = module.db.external_ip_addr
}


#output "lb_ip_addr" {
#  value = [for l in yandex_lb_network_load_balancer.app_lb.listener : l.external_address_spec.*.address].0
#}
