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

  disk_ids = ["epdtrlfakai1t6898458", 
             "fhm0l1mlgrs94eereujp",
             "fhmadbd40b2trgvidcv5",
             "fhmf7qfalm3gatc5jjdj",
             "fhmm0fvdkqlb429cuc1a",
             "fhmiuosfv3i3ruuh11gv"]
}
