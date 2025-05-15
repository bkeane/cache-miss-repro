group "default" {
  targets = ["build"]
}

variable "TAG" {
  description = "Image tag to use for output"
  default = "test:build"
}

target "build" {
  context = "src"
  platforms = ["linux/amd64", "linux/arm64"]
  tag = [TAG]
  load = true
  
  output = [
    "type=image,name=repro,rewrite-timestamp=true",
    "type=docker,name=repro,rewrite-timestamp=true",
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


