# Agent jail

Puts AI agents (coding harnesses) in a Docker container for more isolation.
Useful if you like to run your agents with `--dangerously-skip-permissions`, auto-approving all tool permission requests without prompting.

Needs [Docker](https://www.docker.com/).

## Usage

1. Copy `agent-jail.sh` and `Dockerfile` into your project
2. Set CONTAINER_NAME and IMAGE_NAME in `agent-jail.sh` to something sensible.
3. (optional) Update `Dockerfile` to install extra needed dependencies for your agent
4. (optional) Update the `cmd_run()` function in `agent-jail.sh` to mount extra config files / directories from the host
5. Build the image: `./agent-jail.sh build`
6. Run a container with the image: `./agent-jail.sh run`
7. Enter a shell in the container: `./agent-jail.sh shell`
8. Run your favorite coding harness with `--dangerously-skip-permissions` in `/workspace`
9. Clean up (will stop the container and destroy all state!): `./agent-jail.sh clean`

## Author

Michael Smith
\
who assumes absolutely no liability for any of this, see LICENSE for more information.
