FROM ubuntu:20.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV NICEHASH_USER="NHbVsQYnvZYaFFDuD7rk7qAohCjcw9bEBu35"
ENV NICEHASH_WORKER="H100"
ENV NICEHASH_REGION="hk"
ENV COIN="BTC"
ENV GPU_INDEX="2"

# Install dependencies
RUN apt-get update && \
    apt-get install -y \
    wget \
    curl \
    tar \
    unzip \
    git \
    build-essential \
    cmake \
    libuv1-dev \
    libssl-dev \
    libhwloc-dev \
    nvidia-cuda-toolkit \
    libcurl4-openssl-dev \
    --no-install-recommends && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Create directory for NiceHash
WORKDIR /nicehash

# Download and install XMRig
RUN git clone https://github.com/xmrig/xmrig.git && \
    cd xmrig && \
    mkdir build && \
    cd build && \
    cmake .. -DCUDA_ENABLE=ON -DOpenCL_ENABLE=ON && \
    make -j$(nproc)

# Copy configuration and startup script
COPY config.json /nicehash/xmrig/build/config.json
COPY start-mining.sh /nicehash/start-mining.sh

# Make startup script executable
RUN chmod +x /nicehash/start-mining.sh

# Expose API port
EXPOSE 4067

# Set entrypoint
ENTRYPOINT ["/nicehash/start-mining.sh"]