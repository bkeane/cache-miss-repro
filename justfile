to:
    EPOCH=$(git log -1 --pretty=%ct) \
    TAG=test:test \
    docker buildx bake to --builder=builder-1

from:
    EPOCH=$(git log -1 --pretty=%ct) \
    TAG=test:test \
    docker buildx bake from --builder=builder-2

bust:
    rm -rf .cache

clean:
    docker system prune -f -a
    docker image prune -f -a
    docker buildx prune -f -a

up:
    docker buildx create --driver=docker-container --name=builder-1
    docker buildx create --driver=docker-container --name=builder-2

down:
    docker buildx rm builder-1
    docker buildx rm builder-2