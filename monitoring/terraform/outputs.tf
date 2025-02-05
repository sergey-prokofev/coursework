output "external_ipv4_address" {
    
    value = yandex_vpc_address.network-zabbix-server.external_ipv4_address[0].address
  
}