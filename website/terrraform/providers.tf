terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

provider "yandex" {
  token = var.token
  cloud_id = "b1ge262aciffhrs6noir"
  folder_id = "b1gsm1o1ftsmgc28ausj"
  zone = "ru-central1-a" 
}