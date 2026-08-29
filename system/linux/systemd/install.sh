#!/bin/bash
# Combined setup script for both SYSTEM and USER level systemd services
# 
# How it works:
# - Files in ./bin/ are copied to /usr/local/bin/
# - Units in ./system/ are installed as system services
# - Units in ./user/ are installed as user services
#
# System services: For hardware control (battery limit, etc.)
# User services:   For desktop integration (theme switcher, etc.)

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
EXEC_DIR="$SCRIPT_DIR/bin"
BIN_DEST="/usr/local/bin"

SYSTEM_SERVICE_DIR="$SCRIPT_DIR/system"
SYSTEM_DEST="/etc/systemd/system"

USER_SERVICE_DIR="$SCRIPT_DIR/user"
USER_DEST="$HOME/.config/systemd/user"

# ─────────────────────────────────────────────────────────────────────────────
# Copy all executables to /usr/local/bin
# ─────────────────────────────────────────────────────────────────────────────
echo "╔══════════════════════════════════════════════════════════════════════╗"
echo "║                    Installing Executables                            ║"
echo "╚══════════════════════════════════════════════════════════════════════╝"
echo ""

if [ -d "$EXEC_DIR" ] && [ "$(ls -A "$EXEC_DIR" 2>/dev/null)" ]; then
    for exe_file in "$EXEC_DIR"/*; do
        exe_name=$(basename "$exe_file")
        echo "→ Installing $exe_name..."
        sudo cp "$exe_file" "$BIN_DEST"
        sudo chmod +x "$BIN_DEST/$exe_name"
    done
    echo ""
else
    echo "No executables found in $EXEC_DIR"
    echo ""
fi

# ─────────────────────────────────────────────────────────────────────────────
# Install SYSTEM services (require root, for hardware control)
# ─────────────────────────────────────────────────────────────────────────────
echo "╔══════════════════════════════════════════════════════════════════════╗"
echo "║                    Installing System Services                        ║"
echo "╚══════════════════════════════════════════════════════════════════════╝"
echo ""

if [ -d "$SYSTEM_SERVICE_DIR" ] && [ "$(ls -A "$SYSTEM_SERVICE_DIR" 2>/dev/null)" ]; then
    shopt -s nullglob
    for unit_file in "$SYSTEM_SERVICE_DIR"/*.service "$SYSTEM_SERVICE_DIR"/*.timer; do
        [ -e "$unit_file" ] || continue
        unit_name=$(basename "$unit_file")
        unit_dest="$SYSTEM_DEST/$unit_name"

        echo "→ Installing $unit_name..."
        sudo cp "$unit_file" "$unit_dest"
        sudo chmod 644 "$unit_dest"
    done

    # Reload and enable system services
    echo ""
    echo "Reloading systemd..."
    sudo systemctl daemon-reload

    for unit_file in "$SYSTEM_SERVICE_DIR"/*.service "$SYSTEM_SERVICE_DIR"/*.timer; do
        [ -e "$unit_file" ] || continue
        unit_name=$(basename "$unit_file")
        # Only enable .service files (timers are enabled separately if needed)
        if [[ "$unit_name" == *.service ]]; then
            echo "→ Enabling and starting $unit_name..."
            sudo systemctl enable --now "$unit_name"
        elif [[ "$unit_name" == *.timer ]]; then
            echo "→ Enabling and starting $unit_name..."
            sudo systemctl enable --now "$unit_name"
        fi
    done
    echo ""
else
    echo "No system services found in $SYSTEM_SERVICE_DIR"
    echo ""
fi

# ─────────────────────────────────────────────────────────────────────────────
# Install USER services (run in your session, for desktop integration)
# ─────────────────────────────────────────────────────────────────────────────
echo "╔══════════════════════════════════════════════════════════════════════╗"
echo "║                     Installing User Services                         ║"
echo "╚══════════════════════════════════════════════════════════════════════╝"
echo ""

if [ -d "$USER_SERVICE_DIR" ] && [ "$(ls -A "$USER_SERVICE_DIR" 2>/dev/null)" ]; then
    # Ensure user systemd directory exists
    mkdir -p "$USER_DEST"

    for unit_file in "$USER_SERVICE_DIR"/*.service "$USER_SERVICE_DIR"/*.timer; do
        [ -e "$unit_file" ] || continue
        unit_name=$(basename "$unit_file")

        echo "→ Installing $unit_name..."
        cp "$unit_file" "$USER_DEST/"
    done

    # Reload and enable user services
    echo ""
    echo "Reloading user systemd daemon..."
    systemctl --user daemon-reload

    for unit_file in "$USER_SERVICE_DIR"/*.service "$USER_SERVICE_DIR"/*.timer; do
        [ -e "$unit_file" ] || continue
        unit_name=$(basename "$unit_file")
        if [[ "$unit_name" == *.timer ]]; then
            echo "→ Enabling and starting $unit_name..."
            systemctl --user enable --now "$unit_name"
        elif [[ "$unit_name" == *.service ]]; then
            # For services with timers, don't auto-start (timer handles it)
            timer_name="${unit_name%.service}.timer"
            if [ ! -f "$USER_SERVICE_DIR/$timer_name" ]; then
                echo "→ Enabling and starting $unit_name..."
                systemctl --user enable --now "$unit_name"
            else
                echo "→ Skipping enable for $unit_name (timer will trigger it)..."
                # Do not enable the service; let the timer start it
            fi
        fi
    done
    echo ""
else
    echo "No user services found in $USER_SERVICE_DIR"
    echo ""
fi

# ─────────────────────────────────────────────────────────────────────────────
# Summary
# ─────────────────────────────────────────────────────────────────────────────
echo "╔══════════════════════════════════════════════════════════════════════╗"
echo "║                         Setup Complete!                              ║"
echo "╚══════════════════════════════════════════════════════════════════════╝"
echo ""
echo "Useful commands:"
echo "  System services: sudo systemctl status <service-name>"
echo "  User services:   systemctl --user status <service-name>"
echo "  User logs:       journalctl --user -u <service-name>"
echo ""
