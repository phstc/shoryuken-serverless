#!/usr/bin/env bash

set -e

read -p "Vendorize? (y/n)" YN

if [ "$YN" == "y" ]; then
  (
    cd rails_sample_app
    docker run -v `pwd`:`pwd` -w `pwd` -i -t lambci/lambda:build-ruby2.5 bundle install --deployment --without development test
    docker run -v `pwd`:`pwd` -w `pwd` -i -t lambci/lambda:build-ruby2.5 gem pristine --all
  )
fi

npm run build

cdk deploy