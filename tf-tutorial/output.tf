// A variable for extracting the external IP address of the VM
output "Web-server-URL" {
  value = join("", ["http://", google_compute_instance.vm_instance.network_interface.0.access_config.0.nat_ip, ":5000"])
}