FROM ubuntu:24.04

RUN apt-get update && \
        apt-get install -y curl git ca-certificates sudo && \
        rm -rf /var/lib/apt/lists/*


# Non-root user (recommended)
RUN echo "ubuntu ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers


USER ubuntu
WORKDIR /home/ubuntu

RUN mkdir -p /home/ubuntu/claude /home/ubuntu/projects


# Install Claude Code via the official native installer
RUN curl -fsSL https://claude.ai/install.sh | bash
ENV PATH="/home/ubuntu/.local/bin:${PATH}"

ENV CLAUDE_CONFIG_DIR=/home/ubuntu/claude
