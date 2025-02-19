resource "yandex_vpc_network" "coursework" {
  name = "coursework"
}

resource "yandex_vpc_subnet" "public-subnet" {
  name           = "public-subnet"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.coursework.id
  v4_cidr_blocks = ["10.110.0.0/24"]
}

resource "yandex_vpc_subnet" "private-subnet-1" {
  name           = "private-subnet-1"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.coursework.id
  v4_cidr_blocks = ["10.120.0.0/24"]
}

resource "yandex_vpc_subnet" "private-subnet-2" {
  name           = "private-subnet-2"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.coursework.id
  v4_cidr_blocks = ["10.130.0.0/24"]
}

