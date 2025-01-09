source "incus" "homebrew_configued" {
  image          = "alittlepaintball-homebrew"
  output_image   = "alittlepaintball-homebrew-configured"
  container_name = "alittlepaintball-homebrew-configured"
  reuse          = true
  skip_publish   = false
}

build {
  sources = ["incus.homebrew_configued"]

  provisioner "shell" {
    inline = [
      "cloud-init status --wait",
    ]
  }

  provisioner "shell" {
    scripts = [
      "002-homebrew-configured.sh",
    ]
  }
}
