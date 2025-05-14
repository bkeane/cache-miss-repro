write:
    EPOCH=$(git log -1 --pretty=%ct) \
    TAG=test:test \
    docker buildx bake read-write --progress=plain --load

read:
    EPOCH=$(git log -1 --pretty=%ct) \
    TAG=test:test \
    docker buildx bake read-only --progress=plain --load

bust:
    aws s3 rm --recursive s3://kaixo-buildx-cache/

ls:
    aws s3 ls s3://kaixo-buildx-cache/