source "incus" "ubuntujammy" {
  image          = "images:ubuntu/jammy/cloud"
  output_image   = "alittlepaintball-homebrew"
  container_name = "alittlepaintball-homebrew"
  reuse          = true
  skip_publish   = false
}

build {
  sources = ["incus.ubuntujammy"]

  provisioner "file" {
    source      = "001-homebrew-base.sh"
    destination = "/root/001-homebrew-base.sh"
  }

  provisioner "shell" {
    inline = [
      "cloud-init status --wait",
    ]
  }

  provisioner "shell" {
    scripts = [
      "001-homebrew-base.sh",
    ]
  }
}
