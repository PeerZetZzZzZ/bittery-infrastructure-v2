#!/bin/bash
export BITCOIN_NETWORK=mainnet
export BITCOIND_RPC_USER=wujek
export BITCOIND_RPC_PASSWORD=wujekhaslo
export POSTGRES_DB=bitteryio_${BITCOIN_NETWORK}

docker-compose -f ./docker-compose.only-bitcoin.yaml up -d
