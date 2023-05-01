podman pull $CI_REGISTRY_IMAGE/aarypay-backend:latest
podman pull $CI_REGISTRY_IMAGE/aarypay-file-server:latest

podman stop file-server-aaryapay && podman rm file-server-aaryapay
podman stop backend-aaryapay && podman rm backend-aaryapay

./launch_fileserver.sh
./launch_backend.sh
