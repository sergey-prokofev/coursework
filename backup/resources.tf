resource "yandex_compute_snapshot_schedule" "snapshot" {
  name = "snapshot"

  schedule_policy {
    expression = "0 1 * * *"
  }

  snapshot_count = 7
  snapshot_spec {
      description = "Daily snapshot"
 }

  retention_period = "168h"

  disk_ids = ["epdmd2ss9um7ucmn392u", 
             "fhm2c9psr2vq1vnkf350",
             "fhmdpd0g1vc5at5afjvv",
             "fhmip5bon9i95hjljtm6",
             "fhmiprusjuibn1vm94lj",
             "fhmskhrgpm2ds4k2p2pg",
             "fhmt45q99aveqjep4e29"]
}
