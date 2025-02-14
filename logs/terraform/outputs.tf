output "external_ipv4_address1" {
    value = yandex_vpc_address.network-elasticsearch.external_ipv4_address[0].address
}

output "external_ipv4_address2" {
    value = yandex_vpc_address.network-kibana.external_ipv4_address[0].address
}