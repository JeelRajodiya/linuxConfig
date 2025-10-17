#!/bin/bash
# Restore GRUB_TIMEOUT to default 10 seconds
sudo sed -i 's/^GRUB_TIMEOUT=.*/GRUB_TIMEOUT=10/' /etc/default/grub

# Change GRUB_TIMEOUT_STYLE from hidden to menu (to show the boot menu)
sudo sed -i 's/^GRUB_TIMEOUT_STYLE=.*/GRUB_TIMEOUT_STYLE=menu/' /etc/default/grub

# Apply the changes
sudo update-grub
