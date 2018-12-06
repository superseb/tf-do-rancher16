# Configure the DigitalOcean Provider
provider "digitalocean" {
  token = "${var.do_token}"
}

variable "do_token" {
  default = "xxx"
}

variable "prefix" {
  default = "yourname"
}

variable "rancher_version" {
  default = "v1.6.25"
}

variable "count_agent_cattle_nodes" {
  default = "1"
}

variable "count_agent_kubernetes_nodes" {
  default = "0"
}

variable "admin_password" {
  default = "admin"
}

variable "region_server" {
  default = "lon1"
}

variable "region_agent" {
  default = "lon1"
}

variable "size" {
  default = "s-2vcpu-4gb"
}

variable "cattle_size" {
  default = "s-2vcpu-4gb"
}

variable "kubernetes_size" {
  default = "s-2vcpu-4gb"
}

variable "docker_version_server" {
  default = "17.03"
}

variable "docker_version_agent" {
  default = "17.03"
}

variable "image_server" {
  default = "ubuntu-16-04-x64"
}

variable "image_agent" {
  default = "ubuntu-16-04-x64"
}

variable "ssh_keys" {
  default = []
}

resource "digitalocean_droplet" "rancherserver16" {
  count     = "1"
  image     = "${var.image_server}"
  name      = "${var.prefix}-rancherserver16"
  region    = "${var.region_server}"
  size      = "${var.size}"
  user_data = "${data.template_file.userdata_server.rendered}"
  ssh_keys  = "${var.ssh_keys}"
}

resource "digitalocean_droplet" "rancher16agent-cattle" {
  count     = "${var.count_agent_cattle_nodes}"
  image     = "${var.image_agent}"
  name      = "${var.prefix}-rancheragent16-cattle-${count.index}"
  region    = "${var.region_agent}"
  size      = "${var.cattle_size}"
  user_data = "${data.template_file.userdata_agent.rendered}"
  ssh_keys  = "${var.ssh_keys}"
}

resource "digitalocean_droplet" "rancher16agent-kubernetes" {
  count     = "${var.count_agent_kubernetes_nodes}"
  image     = "${var.image_agent}"
  name      = "${var.prefix}-rancheragent16-kubernetes-${count.index}"
  region    = "${var.region_agent}"
  size      = "${var.kubernetes_size}"
  user_data = "${data.template_file.userdata_agent.rendered}"
  ssh_keys  = "${var.ssh_keys}"
}

data "template_file" "userdata_server" {
  template = "${file("files/userdata_server")}"

  vars {
    docker_version_server = "${var.docker_version_server}"
    rancher_version = "${var.rancher_version}"
  }
}


data "template_file" "userdata_agent" {
  template = "${file("files/userdata_agent")}"

  vars {
    docker_version_agent = "${var.docker_version_agent}"
    server_address = "${digitalocean_droplet.rancherserver16.ipv4_address}"
  }
}

output "rancher-url" {
  value = ["http://${digitalocean_droplet.rancherserver16.ipv4_address}:8080/"]
}
