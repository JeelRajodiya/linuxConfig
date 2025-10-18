#!/bin/bash

# Stop plasmashell
kquitapp5 plasmashell
# Wait for it to stop
sleep 2
# Clear icon cache
rm -f ~/.cache/icon-cache.kcache
# Start plasmashell
kstart5 plasmashell
