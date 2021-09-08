provider "google" {
  credentials = file("/path/to/file")

  project = "<project-id>"
  region  = "europe-west3"
  zone    = "europe-west3-b"
}