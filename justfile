export EPOCH := `git log -1 --pretty=%ct`
export NOW := `date +%s`

default:
    docker buildx bake --progress=plain --load

clean:
    docker system prune -f -a
    docker image prune -f -a
    docker buildx prune -f -a

bust:
    aws s3 rm --recursive s3://kaixo-buildx-cache/

ls:
    aws s3 ls s3://kaixo-buildx-cache/

up: 
    docker buildx create --driver=docker-container --name=container-builder --platform=linux/arm64,linux/amd64 --use

down:
    docker buildx rm container-builder