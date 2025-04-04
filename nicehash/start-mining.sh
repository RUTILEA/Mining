#!/bin/bash

# Check if environment variables are set
if [ -z "$NICEHASH_USER" ] || [ -z "$NICEHASH_WORKER" ]; then
    echo "Error: NICEHASH_USER and NICEHASH_WORKER environment variables must be set."
    echo "Example usage: docker run -e NICEHASH_USER=your_btc_address -e NICEHASH_WORKER=worker_name nicehash-container"
    exit 1
fi

# Determine mining server based on region
case "$NICEHASH_REGION" in
    "usa")
        SERVER="stratum+tcp://usa.nicehash.com:3363"
        ;;
    "eu")
        SERVER="stratum+tcp://eu.nicehash.com:3363"
        ;;
    "hk")
        SERVER="stratum+tcp://hk.nicehash.com:3363"
        ;;
    *)
        echo "Unknown region: $NICEHASH_REGION, defaulting to USA"
        SERVER="stratum+tcp://usa.nicehash.com:3363"
        ;;
esac

echo "Starting XMRig miner..."
echo "User: $NICEHASH_USER"
echo "Worker: $NICEHASH_WORKER"
echo "Server: $SERVER"
echo "Coin: $COIN"
echo "Using GPU Index: $GPU_INDEX"

# Update configuration with environment variables
CONFIG_FILE="/nicehash/xmrig/build/config.json"

# Use jq if available, otherwise use sed
if command -v jq >/dev/null 2>&1; then
    # Create a temporary file
    TMP_CONFIG=$(mktemp)
    
    # Update the pool configuration
    jq --arg url "$SERVER" \
       --arg user "$NICEHASH_USER.$NICEHASH_WORKER" \
       --arg idx "$GPU_INDEX" \
       '.pools[0].url = $url | 
        .pools[0].user = $user | 
        .cuda.devices = [$idx | tonumber]' $CONFIG_FILE > $TMP_CONFIG
    
    # Replace the original file
    mv $TMP_CONFIG $CONFIG_FILE
else
    # Fallback to sed for basic replacements
    sed -i "s|YOUR_POOL_ADDRESS|$SERVER|g" $CONFIG_FILE
    sed -i "s|YOUR_BTC_ADDRESS.YOUR_WORKER_NAME|$NICEHASH_USER.$NICEHASH_WORKER|g" $CONFIG_FILE
    
    # Note: sed is not as reliable for JSON manipulation, especially for arrays
    echo "Warning: jq not found. Basic configuration applied. GPU index might not be set correctly."
fi

# Start mining
cd /nicehash/xmrig/build
./xmrig