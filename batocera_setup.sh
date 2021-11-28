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
version=1  #increment this as the script is updated

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
        else
            while true; do
                printf "${magenta}Your Pixelcade version is already up to date. If you continue, your Pixelcade installation will be deleted including any custom artwork you've added, do you want to re-install? (y/n): ${white}"
                read yn
                case $yn in
                    [Yy]* ) rm -rf /userdata/system/pixelcade; break;;
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
               [Yy]* ) rm -rf /userdata/system/pixelcade; break;;
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

if type -p java ; then
  printf "${yellow}Java already installed, skipping...\n"
  java_installed=true
elif [[ -n "$JAVA_HOME" ]] && [[ -x "$JAVA_HOME/bin/java" ]];  then
  printf "${yellow}Java already installed, skipping...\n"
  java_installed=true
else
   printf "${yellow}Java not found, let's install Java...${white}\n"
   java_installed=false
fi

if [ "$java_installed" = false ] ; then #only install java if it doesn't exist
  printf "${yellow}Installing Zulu Java 8...${white}\n"
  mkdir /userdata/jdk
  cd /userdata/jdk
  curl -kLo - https://cdn.azul.com/zulu-embedded/bin/zulu8.58.0.13-ca-jdk8.0.312-linux_aarch64.tar.gz | gunzip -c | tar -x --strip-components=1
  grep -qxF 'JAVA_HOME=/userdata/jdk/ /userdata/jdk/jre/bin/java -jar /userdata/system/pixelcade/pixelweb.jar -b &' /userdata/system/custom.sh 2> /dev/null || echo 'JAVA_HOME=/userdata/jdk/ /userdata/jdk/jre/bin/java -jar /userdata/system/pixelcade/pixelweb.jar -b &' >> /userdata/system/custom.sh
fi

cd /userdata/system
curl -kLO https://github.com/alinke/pixelcade/archive/refs/heads/master.zip
unzip -q master.zip
mv pixelcade-master/ pixelcade
rm -f master.zip

curl -kLo /userdata/system/scripts/pixelcade.sh https://raw.githubusercontent.com/ACustomArcade/batocera-pixelcade/main/userdata/system/scripts/pixelcade.sh
chmod +x /userdata/system/scripts/pixelcade.sh

JAVA_HOME=/userdata/jdk/ /userdata/jdk/jre/bin/java -jar /userdata/system/pixelcade/pixelweb.jar -b & #run pixelweb in the background

sleep 5
JAVA_HOME=/userdata/jdk/ /userdata/jdk/jre/bin/java -jar /userdata/system/pixelcade/pixelcade.jar -m stream -c animations -g 0arcade-legendsr2

#let's write the version so the next time the user can try and know if they need to upgrade
echo $version > /userdata/system/pixelcade/pixelcade-version
