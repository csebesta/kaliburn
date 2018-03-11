#!/bin/bash
# Kali Linux ISO recipe for minimal rescue image
# Written by Chad Sebesta

# Update and install dependencies
apt-get update
apt-get install git curl live-build cdebootstrap devscripts stow graphicsmagick -y
git clone git://git.kali.org/live-build-config.git
cd live-build-config

# Custom package list
cat > kali-config/variant-default/package-lists/kali.list.chroot << EOF
# Defaults suggested by kali documentation
alsa-tools
#debian-installer-launcher
kali-archive-keyring
kali-debtags
#kali-defaults
#kali-menu
kali-root-login
locales-all
pulseaudio
wireless-tools
xorg

# Desktop environment (slide dependencies)
feh
graphicsmagick
suckless-tools
xmobar
xmonad

# Utilities and tools
firefox-esr
git
gparted
#kali-linux-top10
redshift
rxvt-unicode
stow
vim
EOF

# Modify splash screen
gm convert \
	-size 640x480 xc:#002b36 \
	kali-config/common/bootloaders/grub-pc/splash.png

# Set up slide
git clone https://github.com/csebesta/slide \
kali-config/common/includes.chroot/root/.slide \
&& cd kali-config/common/includes.chroot/root/.slide

# Stow directories
for directory in */; do

	stow -t .. $directory > /dev/null 2>&1 \
	&& echo "Stowed $directory" \
	|| echo "Failed to stow $directory"

done

# Return to previous directory
cd -

# Build image
./build.sh -v