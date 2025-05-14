group "default" {
  targets = ["read-only"]
}

variable "TAG" {
  description = "Image tag to use for output"
  default = "test:test"
}

variable "EPOCH" {
  description = "Source date epoch to use for output"
  default = "0"
}

target "read-only" {
  context = "."
  platforms = ["linux/amd64", "linux/arm64"]
  tag = [TAG]

  output = [
    "type=image,name=${TAG},rewrite-timestamp=true",
    "type=docker,name=${TAG}"
  ]
  
  cache-from = [{
    type = "s3"
    region = "us-west-2"
    bucket = "kaixo-buildx-cache"
    name = "repro"
  }]

  args = {
    SOURCE_DATE_EPOCH = "${EPOCH}"
  }
}

target "read-write" {
  inherits = ["read-only"]

  cache-to = [{
    type = "s3"
    region = "us-west-2"
    bucket = "kaixo-buildx-cache"
    name = "repro"
    mode = "max"
  }]
}