source "incus" "jammy" {
  image          = "images:ubuntu/jammy/cloud"
  output_image   = "alittlepaintball-homebrew"
  container_name = "alittlepaintball-homebrew"
  reuse          = true
  skip_publish   = false
}

build {
  sources = ["incus.jammy"]

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

