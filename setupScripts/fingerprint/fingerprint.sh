#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEB_FILE="libfprint-2-2_1.94.4+tod1-0ubuntu1~22.04.2_amd64_rts5811.deb"

sudo dpkg -i "${SCRIPT_DIR}/${DEB_FILE}"
sudo apt-get install -f -y
sudo apt-mark hold libfprint-2-2
