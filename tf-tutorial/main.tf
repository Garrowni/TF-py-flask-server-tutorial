terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.22.0"
    }
  }
}

provider "google" {
  credentials = file("C:/GCPKeys/python-flask-server-351921-2c8241f65368.json")
  project = "python-flask-server-351921"
  region       = "us-central1"
  zone         = "us-central1-c"
}

resource "google_compute_network" "vpc_network" {
    name = "py-network"
}

resource "google_compute_instance" "vm_instance" {
  name         = "flask-vm"
  machine_type = "f1-micro"

  tags         = ["ssh"]

  metadata = {
    enable-oslogin = "TRUE"
  }
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  # Install Flask
  metadata_startup_script = "sudo apt-get update; sudo apt-get install -yq build-essential python-pip rsync; pip install flask"

  network_interface {
    network = google_compute_network.vpc_network.name

    access_config {
      # Include this section to give the VM an external IP address
    }
  }
}

resource "google_comute_firewall" "ssh" {
    name = "allow-ssh"
    allow {
        ports = ["22"]
        protocol = "tcp"
    }
    direction = "INGRESS"
    network = "default"
    priority = 1000
    source_ranges = ["0.0.0.0/0"]
    target_tags = ["ssh"]
}