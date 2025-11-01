FROM ubuntu:22.04

# Avoid interactive prompts during apt installs
ENV DEBIAN_FRONTEND=noninteractive

# Install minimal dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    git curl build-essential pkg-config libssl-dev jq python3 python3-pip ca-certificates && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Clone Yagna repo (you just want source, not running daemon)
RUN git clone --depth=1 https://github.com/golemfactory/yagna.git /opt/yagna

WORKDIR /opt/yagna

# Add a simple check so Binder sees output
RUN echo "Yagna source cloned successfully!"

# Install Jupyter + fixes for Binder
RUN pip install --no-cache-dir notebook jupyterlab

# Binder exposes port 8888
EXPOSE 8888

# Disable token requirement and allow root (Binder runs as root)
CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--NotebookApp.token=''", "--NotebookApp.password=''", "--allow-root"]

