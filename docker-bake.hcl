group "default" {
  targets = ["build", "release"]
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

target "release" {
  dockerfile = "src/Dockerfile"
  contexts = {
    build = "target:build"
  }
  platforms = ["linux/amd64", "linux/arm64"]
  tag = [RELEASE_TAG]
  load = true

  output = [
    "type=image,name=${RELEASE_TAG}",
    "type=docker,name=${RELEASE_TAG}",
  ]

  args = {
    SOURCE_DATE_EPOCH = "${NOW}"
  }
}

