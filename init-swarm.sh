#!/bin/bash

set -e

DEFAULT="virtualbox"
DRIVER=${1:-$DEFAULT}
ENV=${2:-""}
ID=$(id -un)
USER=${USER:-$ID}
NAME=${3:-$USER}

function usage()
{
    echo "Usage: $0 [driver] [env-file] [name]"
    exit 1
}

function onexit()
{
    err=$?
    if [ $err -ne 0 ]; then
        echo
        usage
    fi
}

trap onexit EXIT

if [[ "$DRIVER" != "$DEFAULT" && ! -e "$DRIVER" ]]; then
    echo "Unable to locate driver env file: $DRIVER"
    echo "(default driver: $DEFAULT)"
    echo
fi

if [[ -n "$ENV" && ! -e "$ENV" ]]; then
    echo "Unable to locate environment file: $ENV"
fi

if [ -n "$ENV" -a -e "$ENV" ]; then
    echo "Configuring machine environment from '$ENV'"
    source $ENV
fi

echo "Using driver:     $DRIVER"
echo "Using swarm name: $NAME"
echo

# create keystore
echo "----- Create machine to deploy the key-value store -----"
docker-machine create -d $DRIVER $NAME-mh-keystore

echo "----- Start consul -----"
docker $(docker-machine config $NAME-mh-keystore) run -d -p "8500:8500" --name="consul" -h "consul" progrium/consul -server -bootstrap

echo "----- Create machine for the swarm master -----"
docker-machine create -d $DRIVER --swarm --swarm-master \
    --swarm-discovery="consul://$(docker-machine ip $NAME-mh-keystore):8500" \
    --engine-opt="cluster-store=consul://$(docker-machine ip $NAME-mh-keystore):8500" \
    --engine-opt="cluster-advertise=eth0:2376" \
    $NAME-swarm-master

for node in {01..03}
do
    echo "----- Create machine for swarm node $node -----"
    docker-machine create -d $DRIVER --swarm \
        --swarm-discovery="consul://$(docker-machine ip $NAME-mh-keystore):8500" \
        --engine-opt="cluster-store=consul://$(docker-machine ip $NAME-mh-keystore):8500" \
        --engine-opt="cluster-advertise=eth0:2376" \
        $NAME-swarm-node-$node
done

echo "----- Display Swarm -----"
docker-machine ls --filter=swarm=$NAME-swarm-master

echo
echo "---- ---------------- -----"
echo "---- Ready to deploy  -----"
echo "---- ---------------- -----"
echo "Run: eval \$(docker-machine env --swarm $NAME-swarm-master)"
