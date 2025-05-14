build:
    TAG=test:test \
    EPOCH=$(git log -1 --pretty=%ct) \
    docker buildx bake read-write --progress=plain --load