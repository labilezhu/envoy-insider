#!/bin/bash

export http_proxy=http://192.168.16.58:8118 && export https_proxy=http://192.168.16.58:8118

sudo apt install python3
sudo apt-get install pip

# pip install --upgrade sphinx-book-theme
# pip install --upgrade myst-parser
# pip install --upgrade configparser
# pip install --upgrade sphinx

sudo apt-get install python3-venv
python3 -m venv .venv 
source .venv/bin/activate

export http_proxy=http://192.168.16.58:8118 && export https_proxy=http://192.168.16.58:8118
pip install -r docs/requirements.txt