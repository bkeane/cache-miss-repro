write:
    EPOCH=$(git log -1 --pretty=%ct) \
    docker buildx bake read-write --progress=plain --load

read:
    EPOCH=$(git log -1 --pretty=%ct) \
    docker buildx bake read-only --progress=plain --load

bust:
    aws s3 rm --recursive s3://kaixo-buildx-cache/