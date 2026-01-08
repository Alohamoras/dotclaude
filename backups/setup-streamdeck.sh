#!/bin/bash

# Stream Deck udev rules setup script
# Run with: sudo ./setup-streamdeck.sh

if [ "$EUID" -ne 0 ]; then
    echo "Please run as root: sudo ./setup-streamdeck.sh"
    exit 1
fi

echo "Creating udev rules for Stream Deck devices..."

cat > /etc/udev/rules.d/70-streamdeck.rules << 'EOF'
# Elgato Stream Deck Original
SUBSYSTEM=="usb", ATTRS{idVendor}=="0fd9", ATTRS{idProduct}=="0060", MODE="0660", TAG+="uaccess"
# Elgato Stream Deck Original (v2)
SUBSYSTEM=="usb", ATTRS{idVendor}=="0fd9", ATTRS{idProduct}=="006d", MODE="0660", TAG+="uaccess"
# Elgato Stream Deck Mini
SUBSYSTEM=="usb", ATTRS{idVendor}=="0fd9", ATTRS{idProduct}=="0063", MODE="0660", TAG+="uaccess"
# Elgato Stream Deck Mini (v2)
SUBSYSTEM=="usb", ATTRS{idVendor}=="0fd9", ATTRS{idProduct}=="0090", MODE="0660", TAG+="uaccess"
# Elgato Stream Deck XL
SUBSYSTEM=="usb", ATTRS{idVendor}=="0fd9", ATTRS{idProduct}=="006c", MODE="0660", TAG+="uaccess"
# Elgato Stream Deck XL (v2)
SUBSYSTEM=="usb", ATTRS{idVendor}=="0fd9", ATTRS{idProduct}=="008f", MODE="0660", TAG+="uaccess"
# Elgato Stream Deck MK.2
SUBSYSTEM=="usb", ATTRS{idVendor}=="0fd9", ATTRS{idProduct}=="0080", MODE="0660", TAG+="uaccess"
# Elgato Stream Deck Pedal
SUBSYSTEM=="usb", ATTRS{idVendor}=="0fd9", ATTRS{idProduct}=="0086", MODE="0660", TAG+="uaccess"
# Elgato Stream Deck Plus
SUBSYSTEM=="usb", ATTRS{idVendor}=="0fd9", ATTRS{idProduct}=="0084", MODE="0660", TAG+="uaccess"
# Elgato Stream Deck Neo
SUBSYSTEM=="usb", ATTRS{idVendor}=="0fd9", ATTRS{idProduct}=="009a", MODE="0660", TAG+="uaccess"
EOF

echo "Reloading udev rules..."
udevadm control --reload-rules
udevadm trigger

echo "Done! Please unplug and replug your Stream Deck, then launch OpenDeck."
