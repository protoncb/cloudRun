resource "google_project_service" "cloudrun" {
  service = "run.googleapis.com"

  disable_dependent_services = true
}

resource "google_cloud_run_service" "mywebapp" {
  depends_on = [google_project_service.cloudrun]

  name     = "loginweb"
  location = "us-central1"

  template {
    spec {
      containers {
        image = "gcr.io/aaron2024/dockertry2:latest"
      }
    }
  }
}

resource "google_cloud_run_service_iam_member" "public_access" {
  depends_on = [google_cloud_run_service.mywebapp]

  service  = google_cloud_run_service.mywebapp.name
  location = google_cloud_run_service.mywebapp.location
  role     = "roles/run.invoker"
  member   = "allUsers"
}

output "cloud_run_url" {
  value = "${google_cloud_run_service.mywebapp.status[0].url}"
}
#for referrence