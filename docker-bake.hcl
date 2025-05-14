group "default" {
  targets = ["read-only"]
}

variable "RELEASE_TAG" {
  description = "Image tag to use for output"
  default = "test:release"
}

variable "BUILD_TAG" {
  description = "Image tag to use for output"
  default = "test:build"
}

variable "NOW" {
  description = "Current timestamp"
}

target "build" {
  context = "."
  platforms = ["linux/amd64", "linux/arm64"]
  tag = [BUILD_TAG]
  load = true

  output = [
    "type=image,name=${BUILD_TAG},rewrite-timestamp=true",
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
    SOURCE_DATE_EPOCH = "0"
  }
}

target "release" {
  contexts = {
    build = "target:build"
  }

  tag = [RELEASE_TAG]
  load = true
  output = [
    "type=image,name=${RELEASE_TAG}",
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
    SOURCE_DATE_EPOCH = "${NOW}"
  }
}