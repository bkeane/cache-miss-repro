variable "BUILD_TAG" {
  description = "Image tag to use for output"
  default = "test:build"
}

variable "EPOCH" {
  description = "Current timestamp"
}

variable "NOW" {
  description = "Current timestamp"
}

target "build" {
  context = "src"
  platforms = ["linux/amd64", "linux/arm64"]
  tag = [BUILD_TAG]
  load = true

  output = [
    "type=image,name=${BUILD_TAG},rewrite-timestamp=true",
    "type=docker,name=${BUILD_TAG},rewrite-timestamp=true",
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

