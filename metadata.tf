# Cloud-Config
data "template_file" "cloud_config" {
  template = "${file("${path.module}/templates/cloud-config.yml.tpl")}"
}

