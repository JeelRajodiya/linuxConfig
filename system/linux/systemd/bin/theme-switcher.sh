#!/bin/bash
# Theme Switcher Script
# Switches between Sweet (night) and OxygenCold (day) based on time

# Configuration
DAY_THEME="OxygenCold"
NIGHT_THEME="Sweet"
DAY_START=6    # 6 AM
NIGHT_START=18 # 6 PM

# Get current hour (24-hour format)
CURRENT_HOUR=$(date +%H)
# Remove leading zero for arithmetic comparison
CURRENT_HOUR=$((10#$CURRENT_HOUR))

# Determine which theme to apply
if [ $CURRENT_HOUR -ge $DAY_START ] && [ $CURRENT_HOUR -lt $NIGHT_START ]; then
    TARGET_THEME="$DAY_THEME"
    TIME_OF_DAY="day"
else
    TARGET_THEME="$NIGHT_THEME"
    TIME_OF_DAY="night"
fi

# Get current theme
CURRENT_THEME=$(plasma-apply-colorscheme --list-schemes 2>/dev/null | grep "(current" | sed 's/ (current color scheme)//' | xargs)

# Only apply if different from current
if [ "$CURRENT_THEME" != "$TARGET_THEME" ]; then
    echo "$(date): Switching from $CURRENT_THEME to $TARGET_THEME ($TIME_OF_DAY mode)"
    plasma-apply-colorscheme "$TARGET_THEME"
else
    echo "$(date): Theme already set to $TARGET_THEME ($TIME_OF_DAY mode)"
fi
