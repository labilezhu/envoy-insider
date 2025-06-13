#!/bin/bash

source .venv/bin/activate

export http_proxy=http://192.168.16.58:8118 && export https_proxy=http://192.168.16.58:8118

pushd ./docs
make html
popd
google-chrome $(pwd)/docs/build/html/index.html