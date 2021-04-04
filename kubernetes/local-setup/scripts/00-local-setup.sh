#!/usr/bin/env bash

BASEDIR=$(dirname "$0")
chmod +x ./$BASEDIR/*.sh
# echo "$BASEDIR"
./$BASEDIR/01-install-kind.sh
./$BASEDIR/02-install-kubectl.sh
./$BASEDIR/03-install-helm.sh
./$BASEDIR/04-install-mc-client.sh

echo "Setup finish"
