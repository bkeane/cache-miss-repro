export COMMIT_TIMESTAMP := `git log -1 --pretty=%ct`
export NOW_TIMESTAMP := `date +%s`

default:
    docker buildx bake --progress=plain \
    --metadata-file metadata.json \
    --debug

clean:
    docker system prune -f -a
    docker image prune -f -a
    docker buildx prune -f -a

bust:
    aws s3 rm --recursive s3://kaixo-buildx-cache/

ls:
    aws s3 ls s3://kaixo-buildx-cache/

up: 
    docker buildx create \
    --driver=docker-container \
    --buildkitd-flags="--allow-insecure-entitlement security.insecure --allow-insecure-entitlement network.host" \
    --name=container-builder \
    --platform=linux/arm64,linux/amd64 \
    --bootstrap --use

down:
    docker buildx rm container-builder