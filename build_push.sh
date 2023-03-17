set -ex

docker build --pull \
 --tag dmikhin/kong28-wallarm:latest .
docker push dmikhin/kong28-wallarm:latest
