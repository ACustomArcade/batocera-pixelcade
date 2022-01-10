# batocera-pixelcade

# This installer is no longer needed!
https://pixelcade.org/batocera

Pixelcade/BitPixel installer for Batocera using LPCB.

Currently supports the following devices:
* Raspberry Pi 4

To install, [SSH to your device](https://wiki.batocera.org/access_the_batocera_via_ssh) and run the following command:

`bash <(curl -s https://raw.githubusercontent.com/ACustomArcade/batocera-pixelcade/main/batocera_setup.sh)`

That's it! Your Pixelcade/BitPixel should display the Legends Ultimate animation.

## Known Issues
Batocera does not support `git` so the artpack installer will not work. Pixelcade/BitPixel will work just fine without it though.
