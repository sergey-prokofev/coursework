output "external_ipv4_address1" {
    value = yandex_vpc_address.network1.external_ipv4_address[0].address
}

output "external_ipv4_address2" {
    value = yandex_vpc_address.network2.external_ipv4_address[0].address
}