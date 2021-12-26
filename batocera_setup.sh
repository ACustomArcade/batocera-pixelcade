#!/bin/bash
pizero=false
pi4=false
java_installed=false
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
blue='\033[0;34m'
magenta='\033[0;35m'
white='\033[0;37m'
reset='\033[0m'
version=3  #increment this as the script is updated

cat << "EOF"
       _          _               _
 _ __ (_)_  _____| | ___ __ _  __| | ___
| '_ \| \ \/ / _ \ |/ __/ _` |/ _` |/ _ \
| |_) | |>  <  __/ | (_| (_| | (_| |  __/
| .__/|_/_/\_\___|_|\___\__,_|\__,_|\___|
|_|
EOF

printf "${magenta}       Pixelcade for Batocera : Installer Version $version    ${white}\n"
echo ""
printf "${red}IMPORTANT:${white} This script will work on a Pi 2, Pi Zero W, Pi 3B, Pi 3B+, and Pi 4\n"
echo "Please also ensure you have at least 500 MB of free disk space"
echo "Now connect Pixelcade to a free USB port on your Pi (directly connected to your Pi or use a powered USB hub)"
echo "Ensure the toggle switch on the Pixelcade board is pointing towards USB and not BT"

# let's check the version and only proceed if the user has an older version
if [[ -d "/userdata/system/pixelcade" ]]; then
    if [[ -f "/userdata/system/pixelcade/pixelcade-version" ]]; then
      echo "Existing Pixelcade installation detected, checking version..."
      read -r currentVersion</userdata/system/pixelcade/pixelcade-version
      if [[ $currentVersion -lt $version ]]; then
            echo "Older Pixelcade version detected, now upgrading..."
            /userdata/system/pixelcade-init.sh stop
            # cleaning up older installers
            if [[ -d "/userdata/jdk" ]]; then
              rm -rf /userdata/jdk
            fi
            sed -i '/\/userdata\/system\/pixelcade-init.sh/d' /userdata/system/custom.sh
            if [[ -f "/userdata/system/gpionext-init.sh" ]];  then
              rm /userdata/system/gpionext-init.sh
            fi
        else
            while true; do
                printf "${magenta}Your Pixelcade version is already up to date. If you continue, your Pixelcade installation will be deleted including any custom artwork you've added, do you want to re-install? (y/n): ${white}"
                read yn
                case $yn in
                    [Yy]* ) /userdata/system/lpcb/init/pixelcade-init.sh stop; rm -rf /userdata/system/pixelcade; break;;
                    [Nn]* ) exit; break;;
                    * ) echo "Please answer y or n";;
                esac
            done
      fi
    else
       while true; do
           printf "${magenta}Your existing Pixelcade installation will be deleted including any custom artwork you've added, do you want to re-install? (y/n): ${white}"
           read yn
           case $yn in
               [Yy]* ) /userdata/system/pixelcade-init.sh stop; rm -rf /userdata/system/pixelcade; break;;
               [Nn]* ) exit; break;;
               * ) echo "Please answer y or n";;
           esac
       done
    fi
fi

# let's detect if Pixelcade is connected
if ls /dev/ttyACM0 | grep -q '/dev/ttyACM0'; then
   printf "${yellow}Pixelcade LED Marquee Detected${white}\n"
else
   printf "${red}Sorry, Pixelcade LED Marquee was not detected, pleasse ensure Pixelcade is USB connected to your Pi and the toggle switch on the Pixelcade board is pointing towards USB, exiting...\n"
   exit 1
fi


if cat /proc/device-tree/model | grep -q 'Pi 4'; then
   printf "${yellow}Raspberry Pi 4 detected...\n"
   pi4=true
fi

if cat /proc/device-tree/model | grep -q 'Pi Zero W'; then
   printf "${yellow}Raspberry Pi Zero detected...\n"
   pizero=true
fi

if [[ -x "/userdata/system/jdk/bin/java" ]]; then
  printf "${yellow}Java already installed, skipping...\n"
  java_installed=true
fi

if [ "$java_installed" = false ] ; then
  printf "${yellow}Installing Zulu Java 8...${white}\n"
  mkdir -p /userdata/system/jdk
  cd /userdata/system/jdk
  curl -kLo - https://cdn.azul.com/zulu-embedded/bin/zulu8.58.0.13-ca-jdk8.0.312-linux_aarch64.tar.gz | gunzip -c | tar -x --strip-components=1
fi

cd /tmp
curl -kLO /tmp/master.zip https://github.com/alinke/pixelcade/archive/refs/heads/master.zip
unzip -q master.zip
mv pixelcade-master/ /userdata/system/pixelcade

# pixelcade required patches were added in batocera v33
if [[ `cat /usr/share/batocera/batocera.version` = 32* ]]; then
      printf "${yellow}Stopping EmulationStation...\n"
      /etc/init.d/S31emulationstation stop
      mount -o remount,rw /boot
      printf "${yellow}Copying patched EmulationStation...\n"
      curl -kLo /boot/boot/overlay https://github.com/ACustomArcade/batocera-pixelcade/raw/main/userdata/system/pixelcade/overlay
      mount -o remount,ro /boot
      sync
fi

mkdir -p /userdata/system/configs/emulationstation/scripts/game-selected
curl -kLo /userdata/system/configs/emulationstation/scripts/game-selected/pixelcade.sh https://raw.githubusercontent.com/ACustomArcade/batocera-pixelcade/main/userdata/system/configs/emulationstation/scripts/game-selected/pixelcade.sh
chmod +x /userdata/system/configs/emulationstation/scripts/game-selected/pixelcade.sh

mkdir -p /userdata/system/configs/emulationstation/scripts/system-selected
curl -kLo /userdata/system/configs/emulationstation/scripts/system-selected/pixelcade.sh https://raw.githubusercontent.com/ACustomArcade/batocera-pixelcade/main/userdata/system/configs/emulationstation/scripts/system-selected/pixelcade.sh
chmod +x /userdata/system/configs/emulationstation/scripts/system-selected/pixelcade.sh

mkdir -p /userdata/system/scripts
curl -kLo /userdata/system/scripts/pixelcade.sh https://raw.githubusercontent.com/ACustomArcade/batocera-pixelcade/main/userdata/system/scripts/pixelcade.sh
chmod +x /userdata/system/scripts/pixelcade.sh

mkdir -p /userdata/system/lpcb/init
curl -kLo /userdata/system/lpcb/init/pixelcade-init.sh https://raw.githubusercontent.com/ACustomArcade/batocera-pixelcade/main/userdata/system/pixelcade-init.sh
chmod +x /userdata/system/lpcb/init/pixelcade-init.sh
grep -qxF '/userdata/system/lpcb/init/pixelcade-init.sh $1' /userdata/system/custom.sh 2> /dev/null || echo '/userdata/system/lpcb/init/pixelcade-init.sh $1' >> /userdata/system/custom.sh

JAVA_HOME=/userdata/system/jdk/ /userdata/system/jdk/jre/bin/java -jar /userdata/system/pixelcade/pixelweb.jar -b & #run pixelweb in the background

curl -kLo /userdata/system/pixelcade/user/batocera.png https://github.com/ACustomArcade/batocera-pixelcade/raw/main/userdata/system/pixelcade/user/batocera.png
sleep 5
JAVA_HOME=/userdata/system/jdk/ /userdata/system/jdk/jre/bin/java -jar /userdata/system/pixelcade/pixelcade.jar -m stream -c user -g batocera
      
#let's write the version so the next time the user can try and know if they need to upgrade
echo $version > /userdata/system/pixelcade/pixelcade-version

echo "Installation complete! Type reboot to restart your system."
