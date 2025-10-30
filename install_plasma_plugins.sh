#!/bin/bash

# ----------------------------------------------------
# Install better blur kwin plugin
# ----------------------------------------------------
# https://github.com/taj-ny/kwin-effects-forceblur

echo "Installing better blur kwin plugin..."
sudo apt install -y git cmake g++ extra-cmake-modules qt6-tools-dev kwin-dev libkf6configwidgets-dev gettext libkf6crash-dev libkf6globalaccel-dev libkf6kio-dev libkf6service-dev libkf6notifications-dev libkf6kcmutils-dev libkdecorations3-dev libxcb-composite0-dev libxcb-randr0-dev libxcb-shm0-dev
cd /tmp
git clone https://github.com/taj-ny/kwin-effects-forceblur
cd kwin-effects-forceblur
mkdir build
cd build
cmake .. -DCMAKE_INSTALL_PREFIX=/usr
make -j$(nproc)
sudo make install
echo "Better blur kwin plugin installed, Go to System Settings > Workspace Behavior > Desktop Effects to enable it (don't forget to disable the default blur effect)!"
