#!/bin/bash
# CHANGE IT
export DOMAIN_NAME=emergencja
# CHANGE IT
export IS_DEVELOPMENT=true
# CHANGE IT
export BITCOIN_NETWORK=regtest
# CHANGE IT
export POSTGRES_USER=master
# CHANGE IT
export POSTGRES_PASSWORD=ofpuppets
# CHANGE IT
  export BITCOIND_RPC_USER=wujek
# CHANGE IT
export BITCOIND_RPC_PASSWORD=wujekhaslo
# CHANGE IT
export POSTGRES_DB=bitteryio_${BITCOIN_NETWORK}
PWD=$(dirname "$0")

docker-compose -f ./docker-compose/docker-compose.common.yaml up -d
#docker-compose -f ./docker-compose/docker-compose.wordpress.yaml up -d

### Generate nginx default.conf
echo 'Generating nginx default.conf'
sudo mkdir -p $PWD/volumes/nginx/conf
if [ $IS_DEVELOPMENT = 'true' ]; then
    cp $PWD/templates/localhost/localhost.default.template.conf $PWD/templates/default.conf
    echo "$(sed -e "s/\$DOMAIN_NAME/${DOMAIN_NAME}/g" \
    $PWD/templates/default.conf | sed -e $'s/\\\\n/\\\n        /g')" > $PWD/templates/default.conf
    sudo mv $PWD/templates/default.conf $PWD/volumes/nginx/conf
    # Create certificates folder with fake certs of LND node
    sudo mkdir -p $PWD/volumes/nginx/certs/app.bittery.io
else
    sudo mkdir -p $PWD/volumes/nginx/certs/app.bittery.io
    sudo cp /etc/letsencrypt/live/bittery.io-0001/fullchain.pem $PWD/volumes/nginx/certs/app.bittery.io
    sudo cp /etc/letsencrypt/live/bittery.io-0001/privkey.pem $PWD/volumes/nginx/certs/app.bittery.io
    cp $PWD/templates/prod/prod.default.template.conf $PWD/templates/default.conf
    echo "$(sed -e "s/\$DOMAIN_NAME/${DOMAIN_NAME}/g" \
    $PWD/templates/default.conf | sed -e $'s/\\\\n/\\\n        /g')" > $PWD/templates/default.conf
    sudo mv $PWD/templates/default.conf $PWD/volumes/nginx/conf
fi
###


echo 'Copying Bittery homepage nginx config'
if [ $IS_DEVELOPMENT = 'false' ]; then
  sudo mkdir -p $PWD/volumes/nginx/certs/bittery.io
  sudo cp /etc/letsencrypt/live/bittery.io-0002/fullchain.pem $PWD/volumes/nginx/certs/bittery.io
  sudo cp /etc/letsencrypt/live/bittery.io-0002/privkey.pem $PWD/volumes/nginx/certs/bittery.io
  sudo cp $PWD/templates/prod/homepage.bittery.prod.conf $PWD/volumes/nginx/conf/bittery.homepage.conf
fi
