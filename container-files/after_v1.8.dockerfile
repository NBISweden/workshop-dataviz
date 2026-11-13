# DOCKER FILE FOR WORKSHOP-ADVANCED-DATA-VISUALIZATION
# 2025 Lokesh Mano

FROM ghcr.io/nbisweden/workshop-adv-data-viz:1.8.0
LABEL Description="Docker image for NBIS workshop"
LABEL Maintainer="lokeshwaran.manoharan@nbis.se"
LABEL org.opencontainers.image.source="https://github.com/NBISweden/workshop-dataviz"
ARG QUARTO_VERSION="1.11.9"

USER root

RUN apt-get update -y \
  && apt-get clean \
  && curl -o quarto-linux-amd64.deb -L https://github.com/quarto-dev/quarto-cli/releases/download/v${QUARTO_VERSION}/quarto-${QUARTO_VERSION}-linux-amd64.deb \
  && apt-get install -y ./quarto-linux-amd64.deb \
  && rm -rf ./quarto-linux-amd64.deb

ARG DEBIAN_FRONTEND=noninteractive

RUN apt update && apt upgrade -y \
  && apt-get install -y python3 python3-pip python3-venv \
      && apt-get clean

# Install VS Code CLI (for `code tunnel`)
RUN curl -fsSL "https://code.visualstudio.com/sha/download?build=stable&os=cli-alpine-x64" -o /tmp/vscode-cli.tar.gz \
  && tar -xzf /tmp/vscode-cli.tar.gz -C /usr/local/bin \
  && rm /tmp/vscode-cli.tar.gz

ENV RETICULATE_PYTHON=/usr/bin/python3
RUN pip install --break-system-packages --upgrade polars "seaborn>=0.13" "pandas>=2.1" plotly altair jupyter
RUN pip install --break-system-packages palmerpenguins
RUN pip install --break-system-packages pyarrow

RUN install2.r --error --skipinstalled tidytuesdayR dygraphs reactable

RUN pip install --break-system-packages --upgrade shiny htmltools

USER rstudio

WORKDIR /qmd
#ENV XDG_CACHE_HOME=/tmp/quarto_cache_home
#ENV XDG_DATA_HOME=/tmp/quarto_data_home
CMD ["quarto", "render"]

