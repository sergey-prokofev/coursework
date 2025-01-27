resource "yandex_compute_disk" "disk1" {
    name = "disk1"
    type = "network-hdd"
    size = 12
    zone = "ru-central1-a"
    image_id = "fd8rg0kng2d1kg23eu3r"
    labels = {
      "project" = "web-server"
    }
}

resource "yandex_compute_disk" "disk2" {
    name = "disk2"
    type = "network-hdd"
    size = 12
    zone = "ru-central1-b"
    image_id = "fd8rg0kng2d1kg23eu3r"
    labels = {
      "project" = "web-server"
    }
}

resource "yandex_vpc_address" "network1" {
    name = "network1"
    external_ipv4_address {
      zone_id = "ru-central1-a"
    }
}

resource "yandex_vpc_address" "network2" {
    name = "network2"
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
      disk_id = yandex_compute_disk.disk1.id
    }

    network_interface {
      subnet_id = "e9bcg66goaevgfarg5i2"
      nat = true
      nat_ip_address = yandex_vpc_address.network1.external_ipv4_address[0].address
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
      disk_id = yandex_compute_disk.disk2.id
    }

    network_interface {
      subnet_id = "e2llllo8ncvrm373k2vi"
      nat = true
      nat_ip_address = yandex_vpc_address.network2.external_ipv4_address[0].address
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


resource "yandex_alb_backend_group" "web-servers-backend-group" {
  name = "backend-group"
 
  http_backend {
    name = "web-servers"
    weight = 1
    port = 80
    target_group_ids = ["ds78sgn7ba21rvuhqnmm"]
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
  labels = {
    "project" = "web-server"
  }
}

resource "yandex_alb_virtual_host" "web-servers-virtual-host" {
  name = "virtual-host"
  http_router_id = yandex_alb_http_router.web-servers-http-router.id
  route {
    name = "web-route"
    http_route {
      http_route_action {
        backend_group_id = "ds73mm285dath65jcrfn"
        timeout = "60s"
      }
    }
  }
}


resource "yandex_alb_load_balancer" "web-servers-balancer" {
  name = "web-servers-balancer"
  network_id = "enpoahtfd0g4ajc8eo54"
  security_group_ids = ["enpsi2lpf1v2b25m4tf7"]

  allocation_policy {
    location {
      zone_id   = "ru-central1-b"
      subnet_id = "e2llllo8ncvrm373k2vi" 
    }
    location {
      zone_id   = "ru-central1-a"
      subnet_id = "e9bcg66goaevgfarg5i2" 
    }
    location {
      zone_id   = "ru-central1-d"
      subnet_id = "fl81s0bosmfeai523knj" 
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