provider "scaleway" {
  organization = "${var.organisation_id}"
  token        = "${var.secret_token}"
  region       = "${var.region}"
}

resource "scaleway_ip" "ip" {
  server = "${scaleway_server.test_server.id}"
}

data "scaleway_image" "ubuntu" {
  architecture = "x86_64"
  name         = "Ubuntu Mini Xenial 25G"
}

resource "scaleway_server" "test_server" {
  name           = "test"
  image          = "${data.scaleway_image.ubuntu.id}"
  type           = "START1-XS"
  state          = "stopped"
  security_group = "${scaleway_security_group.http.id}"
}

resource "scaleway_security_group" "http" {
  name                    = "http"
  description             = "allow HTTP and HTTPS traffic"
  enable_default_security = true
}

resource "scaleway_security_group_rule" "http_accept" {
  security_group = "${scaleway_security_group.http.id}"

  action    = "accept"
  direction = "inbound"
  ip_range  = "0.0.0.0/0"
  protocol  = "TCP"
  port      = 80
}

resource "scaleway_security_group_rule" "https_accept" {
  security_group = "${scaleway_security_group.http.id}"

  action    = "accept"
  direction = "inbound"
  ip_range  = "0.0.0.0/0"
  protocol  = "TCP"
  port      = 443
}

# resource "scaleway_volume" "test_vol" {
#   name       = "test_volume"
#   size_in_gb = 25
#   type       = "l_ssd"
# }


# resource "scaleway_volume_attachment" "test" {
#   server = "${scaleway_server.test_server.id}"
#   volume = "${scaleway_volume.test_vol.id}"
# }


# output "worker_private_ips" {
#   value = ["${scaleway_server.worker.*.private_ip}"]
# }


# output "master_private_ips" {
#   value = ["${scaleway_server.master.*.private_ip}"]
# }


# output "proxy0_private_ips" {
#   value = ["${scaleway_server.proxy0.*.private_ip}"]
# }


# output "proxy1_private_ips" {
#   value = ["${scaleway_server.proxy1.*.private_ip}"]
# }


# output "public_ip" {
#   value = ["${scaleway_server.proxy0.*.public_ip}"]
# }

