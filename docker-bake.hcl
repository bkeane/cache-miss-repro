variable "TAG" {
  description = "Image tag to use for output"
}

target "build" {
  context = "."
  platforms = ["linux/amd64", "linux/arm64"]
  tag = [TAG]

  output = [
    "type=image,name=${TAG}",
  ]
}

target "to" {
  inherits = ["build"]

  cache-to = [{
    type = "local"
    dest = ".cache"
    ignore-error=true
  }]
}

target "from" {
  inherits = ["build"]

  cache-from = [{
    type = "local"
    src = ".cache"
  }]
}