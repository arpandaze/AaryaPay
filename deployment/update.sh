if [ -z "$CI_REGISTRY_IMAGE" ]; then
    CI_REGISTRY_IMAGE="registry.gitlab.com/teamaarya/aaryapaytest"
fi

podman pull $CI_REGISTRY_IMAGE/aaryapay-backend:latest
podman pull $CI_REGISTRY_IMAGE/aaryapay-file-server:latest

podman stop file-server-aaryapay && podman rm file-server-aaryapay
podman stop backend-aaryapay && podman rm backend-aaryapay

./start.sh
