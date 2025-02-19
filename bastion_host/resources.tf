resource "yandex_compute_disk" "bastion-host" {
    name = "bastion-host"
    size = 20
    image_id = "fd870suu28d40fqp8srr"
}

resource "yandex_vpc_address" "bastion-host" {
    name = "bastion-host"
    external_ipv4_address {
      zone_id = "ru-central1-a"
    }
}

resource "yandex_compute_instance" "bastion-host" {
    name = "bastion-host"
    zone = "ru-central1-a"
    resources {
      core_fraction = 20 # Гарантированная доля vCPU
      cores = 2
      memory = 4
    }

    boot_disk {
      disk_id = yandex_compute_disk.bastion-host.id
    }

    network_interface {
      subnet_id = "e9bfanc2ijpkgqjq2m8v"
      nat = true
      nat_ip_address = yandex_vpc_address.bastion-host.external_ipv4_address[0].address
    }

    metadata = {
      user-data = "${file("user-data.yml")}"
    }

    scheduling_policy {
      preemptible = true
    }
}