FROM debian:trixie

RUN apt-get update -y && \
    apt-get install -y --no-install-recommends \
      git \
      curl \
      wget \
      jq \
      yq \
      ca-certificates \
      ssh && \
    rm -rf /var/lib/apt/lists/*

ENV COLORTERM=truecolor

RUN useradd -ms /bin/bash guest

USER guest
WORKDIR /workspace

# Install Google Antigravity CLI
RUN curl -fsSL https://antigravity.google/cli/install.sh | bash

# Install Claude Code CLI
RUN curl -fsSL https://claude.ai/install.sh | bash

RUN mkdir -p ~/.ssh && \
    chmod 700 ~/.ssh && \
    ssh-keyscan github.com >> ~/.ssh/known_hosts

RUN echo 'alias agyed="agy --dangerously-skip-permissions"' >> ~/.bashrc && \
    echo 'alias clauded="claude --dangerously-skip-permissions"' >> ~/.bashrc && \
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc

# Default command - keep container running
CMD ["bash"]
