group "default" {
  targets = ["build"]
}

variable "BUILD_TAG" {
  description = "Image tag to use for output"
  default = "test:build"
}

variable "RELEASE_TAG" {
  description = "Image tag to use for output"
  default = "test:release"
}

variable "EPOCH" {
  description = "Epoch timestamp"
  default = "0"
}

variable "NOW" {
  description = "Current timestamp"
}

target "build" {
  matrix = {
    arch = ["amd64", "arm64"]
  }

  name = "${arch}"
  context = "src"

  platforms = ["linux/${arch}"]
  tag = ["repro:${arch}"]

  output = [
    "type=image,name=repro-${arch},rewrite-timestamp=true",
  ]

  cache-to = [{
    type = "s3"
    region = "us-west-2"
    bucket = "kaixo-buildx-cache"
    name = "repro"
    prefix = "${arch}"
    mode = "max"
  }]
  
  cache-from = [{
    type = "s3"
    region = "us-west-2"
    bucket = "kaixo-buildx-cache"
    name = "repro"
    prefix = "${arch}"
  }]

  args = {
    SOURCE_DATE_EPOCH = "${EPOCH}"
  }
}


