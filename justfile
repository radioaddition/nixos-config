_default:
    @echo Available commands:
    @echo just install ACTION ARGUMENT
    @echo ""
    @echo Available ACTIONs:
    @echo "	disk: ARGUMENT should be a block device (ie /dev/sda)"
    @echo "	finish: ARGUMENT should be a hostname, defaults to {{ argument }}"
    @echo "This script will first install a copy of its own flake to your disk (to avoid errors with the installer running out of storage)"
    @echo "Then, if you copy this script to the root folder of your nix config directory, will finish the install for you, automatically"
    @echo "adding your auto-generated hardware config (excluding filesystem information since you should have that preconfigured anyways)"
    @echo ""
    @echo ""
    @echo "just format"
    @echo format the code in this repo
    @echo ""
    @echo ""
    @echo "just fmt"
    @echo alias for \"just format\"
    @echo ""
    @echo ""
    @echo just setup-secureboot KEYS
    @echo "set up secureboot, where KEYS is one of \"microsoft\" or \"tpm-eventlog\" ({{ keys }} is recommended and the default)"
    @echo "Secureboot should be in setup mode in your uefi prior to running this and the configuration being switched to should have lanzaboote enabled"

# just install ACTION ARGUMENT
argument := `hostname`
install action argument:
    #!/usr/bin/env bash
    set -euo pipefail
    # make annoying error shut up
    sudo mkdir -p /nix/var/nix/profiles/per-user/root/channels
    if [ "{{ action }}" == "finish" ]; then
    	echo "This assumes you are on the #installer flake, CD'd into your nix config directory and have the remote authentication set up"
    	nixos-generate-config --no-filesystems --root /tmp
    	mv /tmp/etc/nixos/hardware-configuration.nix ./hosts/"{{ argument }}"/
    	rm -rf /tmp/etc
    	if [ ! "git status | rg clean" ]; then
    		git add ./hosts/{{ argument }}/hardware-configuration.nix
    		git commit -m "add hardware-configuration.nix for {{ argument }}"
    		git push
    	fi
    	sudo nixos-rebuild boot --flake ".#{{ argument }}" --install-bootloader
    	home-manager switch --flake ".#{{ argument }}"
    else
    	nixos-generate-config --no-filesystems --root /tmp
    	mv /tmp/etc/nixos/hardware-configuration.nix ./hosts/installer/
    	rm -rf /tmp/etc
    	if [ -d ".git" ]; then
    		git add ./hosts/installer/hardware-configuration.nix
    	fi
    	sudo disko-install --flake ".#installer" --disk main "{{ argument }}"
    fi

alias fmt := format

# Formats my spahetti code
format:
    deadnix --edit
    nix fmt $HOME/nixos-config

# Sets up using these commands from the home directory
[no-cd]
setup:
    @ln -s "$PWD"/justfile "$HOME"/justfile

keys := "microsoft"
setup-secureboot keys:
    sudo sbctl create-keys
    nh os boot . -H $(hostname) -a
    sudo sbctl verify
    sudo sbctl enroll-keys --{{ keys }}

test:
    nix eval .#nixosConfigurations.$(hostname).config.system.build.toplevel

# Useful for new installs or kernel changes
enroll-tpm:
    -sudo systemd-cryptenroll /dev/disk/by-partlabel/disk-main-luks --wipe-slot=tpm2
    sudo systemd-cryptenroll --tpm2-device=auto --tpm2-with-pin=yes --tpm2-pcrs="7+14" /dev/disk/by-partlabel/disk-main-luks

# Useful for new installs or kernel changes
enroll-fido2:
    -sudo systemd-cryptenroll /dev/disk/by-partlabel/disk-main-luks --wipe-slot=fido2
    sudo systemd-cryptenroll --fido2-device=auto --fido2-with-client-pin=no --fido2-with-user-presence=yes /dev/disk/by-partlabel/disk-main-luks

# Setup dev environment
env:
    @nix --extra-experimental-features "nix-command flakes" develop
