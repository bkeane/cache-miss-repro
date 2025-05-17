group "default" {
  targets = ["build"]
}

variable "COMMIT_TIMESTAMP" {
  description = "Commit timestamp"
}

variable "NOW_TIMESTAMP" {
  description = "Current timestamp"
}

target "build" {
  matrix = {
    arch = ["amd64", "arm64"]
  }

  name = "${arch}"
  context = "src"
  platforms = ["linux/${arch}"]
  tag = ["${arch}"]
  load = true 
  
  output = [
    "type=image,name=${arch},rewrite-timestamp=true",
    "type=docker,name=${arch},rewrite-timestamp=true",
  ]

  args = {
    SOURCE_DATE_EPOCH = "0"
  }

 cache-to = [{
     type = "s3"
     region = "us-west-2"
     bucket = "kaixo-buildx-cache"
     name = "repro"
     prefix = "${arch}/"
     mode = "max"
 }]
  
  cache-from = [{
    type = "s3"
    region = "us-west-2"
    bucket = "kaixo-buildx-cache"
    name = "repro"
    prefix = "${arch}/"
  }]
}

target "release" {
  context = "src"
  platforms = ["linux/amd64", "linux/arm64"]
  tag = ["repro:latest"]
  load = true

  output = [
    "type=image,name=repro-multi",
    "type=docker,name=repro-multi",
  ]
}