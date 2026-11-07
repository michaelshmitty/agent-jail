#!/usr/bin/env sh
set -e

CONTAINER_NAME="unnamed-project-container"
IMAGE_NAME="unnamed-project-image"

usage() {
  cat <<EOF
Usage: $0 <command> [arguments]

Manage the $IMAGE_NAME Docker environment.

Commands:
  build    Build the Docker image ($IMAGE_NAME)
  run      Run the container in the background
  shell    Open an interactive bash shell in the running container
  stop     Stop and remove the running container
  clean    Stop and remove the container, and remove the image
  help     Show this help message
EOF
}

cmd_build() {
  docker build -t "$IMAGE_NAME" "$@" .
}

cmd_clean() {
  docker stop "$CONTAINER_NAME" || true
  docker rm "$CONTAINER_NAME" || true
  docker rmi "$IMAGE_NAME" || true
}

cmd_run() {
  docker run -d \
    --name "$CONTAINER_NAME" \
    --hostname "$CONTAINER_NAME" \
    -v $PWD:/workspace \
    -v $HOME/.claude:/home/guest/.claude \
    -e CLAUDE_CONFIG_DIR=/home/guest/.claude \
    -v $HOME/.ssh/known_hosts:/home/guest/.ssh/known_hosts:ro \
    -v $HOME/.gitconfig:/home/guest/.gitconfig:ro \
    -v $HOME/.gitignore:/home/guest/.gitignore:ro \
    -v /run/host-services/ssh-auth.sock:/run/host-services/ssh-auth.sock \
    -e SSH_AUTH_SOCK=/run/host-services/ssh-auth.sock \
    -e TERM="$TERM" \
    -p 5173:5173 \
    -it \
    "$IMAGE_NAME"
  docker exec -u root "$CONTAINER_NAME" chmod 666 /run/host-services/ssh-auth.sock
  echo "Container started. Use '$0 shell' to access it"
}

cmd_shell() {
  if [ $# -gt 0 ]; then
    docker exec -it "$CONTAINER_NAME" "$@"
  else
    docker exec -it "$CONTAINER_NAME" bash
  fi
}

cmd_stop() {
  docker stop "$CONTAINER_NAME" || true
  docker rm "$CONTAINER_NAME" || true
}

case "$1" in
  build)
    shift
    cmd_build "$@"
    ;;
  clean)
    shift
    cmd_clean "$@"
    ;;
  run)
    shift
    cmd_run "$@"
    ;;
  shell)
    shift
    cmd_shell "$@"
    ;;
  stop)
    shift
    cmd_stop "$@"
    ;;
  help|-h|--help)
    usage
    exit 0
    ;;
  "")
    usage >&2
    exit 1
    ;;
  *)
    echo "Error: Unknown command '$1'" >&2
    echo "" >&2
    usage >&2
    exit 1
    ;;
esac
