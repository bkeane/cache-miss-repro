group "default" {
  targets = ["build", "release"]
}

target "build" {
  matrix = {
    arch = ["amd64", "arm64"]
  }

  name = "${arch}"
  context = "src"
  platforms = ["linux/${arch}"]
  output = [
    "type=image,name=${arch}",
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
