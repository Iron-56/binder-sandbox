FROM ubuntu:22.04

# Set noninteractive mode for faster build (avoids tzdata prompts)
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies for Yagna CLI and Jupyter
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        python3 python3-pip git curl build-essential pkg-config \
        libssl-dev jq ca-certificates sudo && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Create Binder-friendly user (jovyan)
RUN useradd -m -s /bin/bash jovyan && echo "jovyan ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER jovyan
WORKDIR /home/jovyan

# Clone Yagna into user's home directory
RUN git clone --depth=1 https://github.com/golemfactory/yagna.git yagna

WORKDIR /home/jovyan/yagna

# Display confirmation
RUN ls && echo "Yagna source ready! (no systemd, no network daemon running)"

# Install Jupyter Notebook
RUN pip install --no-cache-dir notebook

# Expose Binder’s expected port
EXPOSE 8888

# Final CMD: start notebook on 0.0.0.0
CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--no-browser", "--allow-root"]
