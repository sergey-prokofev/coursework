resource "yandex_vpc_security_group" "bastion" {
  name        = "bastion-host"
  description = "Description for security group"
  network_id  = "enpr6634742j94h241d0"

  ingress {
    protocol       = "ANY"
    description    = "Разрешает подключение по порту 22"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 22
  }

  egress {
    protocol       = "ANY"
    description    = "Разрешает подключение по порту 22"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 22
  }
}

###########################################

resource "yandex_vpc_security_group" "web" {
  name        = "webserver"
  description = "Description for security group"
  network_id  = "enpr6634742j94h241d0"

  ingress {
    protocol       = "TCP"
    description    = "Allow HTTP protocol"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 80
  }

  ingress {
    protocol          = "ANY"
    description       = "Разрешает взаимодействие между ресурсами текущей группы безопасности"
    predefined_target = "self_security_group"
    from_port         = 0
    to_port           = 65535
  }

  ingress {
    protocol           = "TCP"
    description        = "Разрешает подключение по порту 22 со стороны ресурсов с группой безопасности bastion"
    security_group_id  = yandex_vpc_security_group.bastion.id
    port               = 22
  }
  
  egress {
    protocol       = "ANY"
    description    = "ALL"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}






resource "yandex_vpc_security_group" "Kibana" {
  name        = "Kibana"
  description = "Description for security group"
  network_id  = "enpr6634742j94h241d0"

  ingress {
    protocol       = "ANY"
    description    = "Allow HTTP protocol"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 5601
  }

  ingress {
    protocol          = "ANY"
    description       = "Разрешает взаимодействие между ресурсами текущей группы безопасности"
    predefined_target = "self_security_group"
    from_port         = 0
    to_port           = 65535
  }

  ingress {
    protocol           = "TCP"
    description        = "Разрешает подключение по порту 22 со стороны ресурсов с группой безопасности bastion"
    security_group_id  = yandex_vpc_security_group.bastion.id
    port               = 22
  }
  
  egress {
    protocol       = "ANY"
    description    = "ALL"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}





resource "yandex_vpc_security_group" "zabbix" {
  name        = "zabbix"
  description = "Description for security group"
  network_id  = "enpr6634742j94h241d0"

  ingress {
    protocol       = "TCP"
    description    = "Allow HTTP protocol"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 80
  }

  ingress {
    protocol          = "ANY"
    description       = "Разрешает взаимодействие между ресурсами текущей группы безопасности"
    predefined_target = "self_security_group"
    from_port         = 0
    to_port           = 65535
  }

  ingress {
    protocol           = "TCP"
    description        = "Разрешает подключение по порту 22 со стороны ресурсов с группой безопасности bastion"
    security_group_id  = yandex_vpc_security_group.bastion.id
    port               = 22
  }
  
  egress {
    protocol       = "ANY"
    description    = "ALL"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}





resource "yandex_vpc_security_group" "elasticsearch" {
  name        = "elasticsearch"
  description = "Description for security group"
  network_id  = "enpr6634742j94h241d0"

  ingress {
    protocol       = "TCP"
    description    = "Allow HTTP protocol"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 9200
  }

  ingress {
    protocol          = "ANY"
    description       = "Разрешает взаимодействие между ресурсами текущей группы безопасности"
    predefined_target = "self_security_group"
    from_port         = 0
    to_port           = 65535
  }

  ingress {
    protocol           = "TCP"
    description        = "Разрешает подключение по порту 22 со стороны ресурсов с группой безопасности bastion"
    security_group_id  = yandex_vpc_security_group.bastion.id
    port               = 22
  }
  
  egress {
    protocol       = "ANY"
    description    = "ALL"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}