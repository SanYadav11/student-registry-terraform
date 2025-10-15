
# -----------------------------------------------------
# 1️⃣ Enable required APIs
# -----------------------------------------------------
resource "google_project_service" "logging_api" {
  service = "logging.googleapis.com"
}

resource "google_project_service" "monitoring_api" {
  service = "monitoring.googleapis.com"
}

# -----------------------------------------------------
# 2️⃣ Create a BigQuery dataset for long-term log storage
# -----------------------------------------------------
resource "google_bigquery_dataset" "app_logs_dataset" {
  dataset_id = "springboot_logs"
  location   = var.region
  description = "Stores application logs exported from Cloud Logging"
}

# -----------------------------------------------------
# 3️⃣ Create a Cloud Logging sink that exports logs to BigQuery
# -----------------------------------------------------
resource "google_logging_project_sink" "app_logs_sink" {
  name                   = "springboot-log-sink"
  destination            = "bigquery.googleapis.com/projects/${var.project_id}/datasets/${google_bigquery_dataset.app_logs_dataset.dataset_id}"
  filter                 = "resource.type=\"k8s_container\" AND textPayload:(\"ERROR\" OR \"Exception\")"
  unique_writer_identity = true
}

# Grant sink service account permission to write to BigQuery
resource "google_bigquery_dataset_iam_member" "sink_writer" {
  dataset_id = google_bigquery_dataset.app_logs_dataset.dataset_id
  role       = "roles/bigquery.dataEditor"
  member     = google_logging_project_sink.app_logs_sink.writer_identity
}

# -----------------------------------------------------
# 4️⃣ Monitoring Dashboard (CPU, Memory, Logs)
# -----------------------------------------------------
resource "google_monitoring_dashboard" "springboot_dashboard" {
  dashboard_json = jsonencode({
    displayName = "Spring Boot Application Monitoring"
    gridLayout = {
      columns = 2
      widgets = [
        {
          title = "GKE Pod CPU Utilization"
          xyChart = {
            dataSets = [{
              timeSeriesQuery = {
                timeSeriesFilter = {
                  filter = "metric.type=\"kubernetes.io/container/cpu/utilization\""
                  aggregation = {
                    alignmentPeriod = "60s"
                    perSeriesAligner = "ALIGN_MEAN"
                  }
                }
              }
            }]
          }
        },
        {
          title = "Pod Memory Utilization"
          xyChart = {
            dataSets = [{
              timeSeriesQuery = {
                timeSeriesFilter = {
                  filter = "metric.type=\"kubernetes.io/container/memory/utilization\""
                  aggregation = {
                    alignmentPeriod = "60s"
                    perSeriesAligner = "ALIGN_MEAN"
                  }
                }
              }
            }]
          }
        }
      ]
    }
  })
}


#
# Notification Channel Creation
#

resource google_monitoring_notification_channel "email" {

display_name = "Ops email"
type = "email"
labels = {
   email_address = "jbs.in222@gmail.com"
}

}

# -----------------------------------------------------
# 5️⃣ Alert Policy (trigger on Spring Boot ERROR logs)
# -----------------------------------------------------
resource "google_monitoring_alert_policy" "springboot_error_alert" {
  display_name = "Spring Boot ERROR log alert"
  combiner     = "OR"

  conditions {
    display_name = "App logs contain ERROR"
    condition_matched_log {
      filter = "resource.type=\"k8s_container\" AND textPayload:\"ERROR\""
    }
  }

 # Required for log-based alerts
  alert_strategy {
    notification_rate_limit {
      period = "3600s" # 1 notification per hour max
    }
  }

  notification_channels = [google_monitoring_notification_channel.email.id]

  documentation {
    content   = "An ERROR log was detected in the Spring Boot application."
    mime_type = "text/markdown"
  }
}

