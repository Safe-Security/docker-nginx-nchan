# Desc: Build script for nginx-nchan
# build for amd64, arm64
docker buildx build --platform linux/amd64,linux/arm64 -t darkflib/nginx-nchan:latest -t darkflib/nginx-nchan:1.24.0 --push .
