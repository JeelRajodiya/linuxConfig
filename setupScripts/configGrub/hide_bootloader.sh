#!/bin/bash
# Replace GRUB_TIMEOUT=10 with GRUB_TIMEOUT=0
sudo sed -i 's/GRUB_TIMEOUT=10/GRUB_TIMEOUT=2/' /etc/default/grub

# Add GRUB_TIMEOUT_STYLE=hidden if it doesn't exist
grep -q "GRUB_TIMEOUT_STYLE" /etc/default/grub || echo "GRUB_TIMEOUT_STYLE=hidden" | sudo tee -a /etc/default/grub

# If GRUB_TIMEOUT_STYLE exists but isn't set to hidden, update it
sudo sed -i 's/^GRUB_TIMEOUT_STYLE=.*/GRUB_TIMEOUT_STYLE=hidden/' /etc/default/grub

# Apply the changes
sudo update-grub
