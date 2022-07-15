#!/bin/bash

cd $(dirname $0)

if [[ $(jq -r .source.json meta.json) == http* ]]
then
  CURLOPTS='-L -c /tmp/cookies -A eps/1.2'
  curl $CURLOPTS -o 36.json $(jq -r .source.json meta.json)
fi

cd ~-
