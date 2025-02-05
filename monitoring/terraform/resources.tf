resource "yandex_compute_disk" "disk-zabbix-server" {
    name = "disk-zabbix-server"
    size = 20
    image_id = "fd870suu28d40fqp8srr"
    labels = {
      "project" = "zabbix-server"
    }
  

}

resource "yandex_vpc_address" "network-zabbix-server" {
    name = "network"
    external_ipv4_address {
      zone_id = "ru-central1-a"
    }
  
}

resource "yandex_compute_instance" "zabbix-server" {
    name = "zabbix-server"
    zone = "ru-central1-a"
    resources {
      core_fraction = 20 # Гарантированная доля vCPU
      cores = 4
      memory = 8
    }

    boot_disk {
      disk_id = yandex_compute_disk.disk-zabbix-server.id
    }

    network_interface {
      subnet_id = "e9bkrdr2afi4mjq4lr3h"
      nat = true
      nat_ip_address = yandex_vpc_address.network-zabbix-server.external_ipv4_address[0].address
    }

    metadata = {
      user-data = "${file("user-data.yml")}"
    }

    scheduling_policy {
      preemptible = true
    }
}