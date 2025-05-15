group "default" {
  targets = ["build"]
}

variable "TAG" {
  description = "Image tag to use for output"
  default = "test:build"
}

variable "EPOCH" {
  description = "Epoch timestamp"
  default = "0"
}

variable "NOW" {
  description = "Current timestamp"
}

target "build" {
  context = "src"
  platforms = ["linux/amd64", "linux/arm64"]
  tag = [TAG]
  load = true

  output = [
    "type=image,name=${TAG},rewrite-timestamp=true",
    "type=docker,name=${TAG},rewrite-timestamp=true",
  ]

  cache-to = [{
    type = "s3"
    region = "us-west-2"
    bucket = "kaixo-buildx-cache"
    name = "repro"
    mode = "max"
  }]
  
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


