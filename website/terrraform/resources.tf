resource "yandex_compute_disk" "web1" {
    name = "web1"
    type = "network-hdd"
    size = 12
    zone = "ru-central1-a"
    image_id = "fd8rg0kng2d1kg23eu3r"
}

resource "yandex_compute_disk" "web2" {
    name = "web2"
    type = "network-hdd"
    size = 12
    zone = "ru-central1-b"
    image_id = "fd8rg0kng2d1kg23eu3r"
}

resource "yandex_vpc_address" "web1" {
    name = "web1"
    external_ipv4_address {
      zone_id = "ru-central1-a"
    }
}

resource "yandex_vpc_address" "web2" {
    name = "web2"
    external_ipv4_address {
      zone_id = "ru-central1-b"
    }
}

resource "yandex_compute_instance" "webserver1" {
    name = "webserver1"
    zone = "ru-central1-a"

    resources {
      core_fraction = 20 # Гарантированная доля vCPU
      cores = 2
      memory = 2
    }

    boot_disk {
      disk_id = yandex_compute_disk.web1.id
    }

    network_interface {
      subnet_id = "e9bfanc2ijpkgqjq2m8v"
      nat = true
      nat_ip_address = yandex_vpc_address.web1.external_ipv4_address[0].address
    }

    metadata = {
      user-data = "${file("user-data.yml")}"
    }

    scheduling_policy {
      preemptible = true
    }
}

resource "yandex_compute_instance" "webserver2" {
    name = "webserver2"
    zone = "ru-central1-b"

    resources {
      core_fraction = 20 # Гарантированная доля vCPU
      cores = 2
      memory = 2
    }

    boot_disk {
      disk_id = yandex_compute_disk.web2.id
    }

    network_interface {
      subnet_id = "e2lk0vs7ouc582cjp4mn"
      nat = true
      nat_ip_address = yandex_vpc_address.web2.external_ipv4_address[0].address
    }

    metadata = {
      user-data = "${file("user-data.yml")}"
    }

    scheduling_policy {
      preemptible = true
    }
}


resource "yandex_alb_target_group" "web-servers-target-group" {
  name = "web-servers"
  target {
    subnet_id = yandex_compute_instance.webserver1.network_interface.0.subnet_id
    ip_address   = yandex_compute_instance.webserver1.network_interface.0.ip_address
  }

  target {
    subnet_id = yandex_compute_instance.webserver2.network_interface.0.subnet_id
    ip_address   = yandex_compute_instance.webserver2.network_interface.0.ip_address
  }
}

#########################################################################################
resource "yandex_alb_backend_group" "web-servers-backend-group" {
  name = "backend-group"
 
  http_backend {
    name = "web-servers"
    weight = 1
    port = 80
    target_group_ids = ["ds7dfvkokco5f7b58ajr"]
    load_balancing_config {
      panic_threshold = 90
    }
    healthcheck {
      timeout              = "10s"
      interval             = "5s"
      healthy_threshold    = 10
      unhealthy_threshold  = 20
      http_healthcheck {
        path = "/"
        #host = "<данные_от_эндпоинта>"
      }
    }
  }
}

resource "yandex_alb_http_router" "web-servers-http-router" {
  name = "http-router"
}

##################################################################

resource "yandex_alb_virtual_host" "web-servers-virtual-host" {
  name = "virtual-host"
  http_router_id = yandex_alb_http_router.web-servers-http-router.id
  route {
    name = "web-route"
    http_route {
      http_route_action {
        backend_group_id = "ds7c569vfbfioopf737p"
        timeout = "60s"
      }
    }
  }
}


resource "yandex_alb_load_balancer" "web-servers-balancer" {
  name = "web-servers-balancer"
  network_id = "enpr6634742j94h241d0"
  security_group_ids = ["enpgjct6n8ri5vgb7tab"]

  allocation_policy {
    location {
      zone_id   = "ru-central1-a"
      subnet_id = "e9bqj3op0aq4dn7o1u6l" 
    }
  }

  listener {
    name = "listener1"
    endpoint {
      address {
        external_ipv4_address {
        }
      }
      ports = [ 80 ]
    }
    http {
      handler {
        http_router_id = yandex_alb_http_router.web-servers-http-router.id
      }
    }
  }
}