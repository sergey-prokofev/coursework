resource "yandex_compute_disk" "disk-elasticsearch" {
    name = "disk-elasticsearch"
    type = "network-hdd"
    size = 12
    zone = "ru-central1-a"
    image_id = "fd8rg0kng2d1kg23eu3r"
}

resource "yandex_compute_disk" "disk-kibana" {
    name = "disk-kibana"
    type = "network-hdd"
    size = 12
    zone = "ru-central1-b"
    image_id = "fd8rg0kng2d1kg23eu3r"
}

resource "yandex_vpc_address" "network-elasticsearch" {
    name = "network-elasticsearch"
    external_ipv4_address {
      zone_id = "ru-central1-a"
    }
}

resource "yandex_vpc_address" "network-kibana" {
    name = "network-kibana"
    external_ipv4_address {
      zone_id = "ru-central1-b"
    }
}

resource "yandex_compute_instance" "elasticsearch" {
    name = "elasticsearch"
    zone = "ru-central1-a"

    resources {
      core_fraction = 20 # Гарантированная доля vCPU
      cores = 4
      memory = 4
    }

    boot_disk {
      disk_id = yandex_compute_disk.disk-elasticsearch.id
    }

    network_interface {
      subnet_id = "e9bcg66goaevgfarg5i2"
      nat = true
      nat_ip_address = yandex_vpc_address.network-elasticsearch.external_ipv4_address[0].address
    }

    metadata = {
      user-data = "${file("user-data.yml")}"
    }

    scheduling_policy {
      preemptible = true
    }
}

resource "yandex_compute_instance" "kibana" {
    name = "kibana"
    zone = "ru-central1-b"

    resources {
      core_fraction = 20 # Гарантированная доля vCPU
      cores = 2
      memory = 2
    }

    boot_disk {
      disk_id = yandex_compute_disk.disk-kibana.id
    }

    network_interface {
      subnet_id = "e2llllo8ncvrm373k2vi"
      nat = true
      nat_ip_address = yandex_vpc_address.network-kibana.external_ipv4_address[0].address
    }

    metadata = {
      user-data = "${file("user-data.yml")}"
    }

    scheduling_policy {
      preemptible = true
    }
}

