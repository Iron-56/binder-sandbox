FROM ubuntu:22.04

# Install dependencies for building Yagna CLI
RUN apt-get update && \
    apt-get install -y git curl build-essential pkg-config libssl-dev jq python3 python3-pip && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Clone the official Yagna repository
RUN git clone --depth=1 https://github.com/golemfactory/yagna.git /opt/yagna

WORKDIR /opt/yagna

# Build or just inspect it
RUN ls && echo "Yagna source ready! (no systemd, no network daemon running)"

# Install Jupyter for Binder
RUN pip install notebook

CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--no-browser", "--allow-root"]
