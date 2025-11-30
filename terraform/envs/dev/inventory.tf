# --------------------------------------------
# ANSIBLE INVENTORY GENERATION
# --------------------------------------------
resource "local_file" "ansible_inventory" {
  filename = "${path.module}/../../../ansible/inventory/hosts.yaml"

  content = templatefile("${path.module}/templates/inventory.tmpl", {
    hosts = local.instance_map
  })

  file_permission      = "0644"
  directory_permission = "0755"
}
