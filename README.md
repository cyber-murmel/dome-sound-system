# Dome Sound System
A simple Raspberry Pi audio server based on [NixOS on ARM Examples](https://github.com/cyber-murmel/NixOS-on-ARM-Examples)

## Features
- PulseAudio TCP server
- Avahi Zeroconf
- Shairport Sync (buggy as of now)
- PCM DAC

## Customizing
To setup wireless networking and public SSH keys, etc., copy `custom-template.nix` to `custom.nix` and edit its content to your requirements.

## Building
```bash
$ export MACHINE=raspberry-pi-3
# nixpkgs pinned to nixos-23.05 2023-07-06
$ export NIXPKGS="https://github.com/NixOS/nixpkgs/archive/c99004f.tar.gz"
$ nix-build -I nixpkgs=$NIXPKGS -I machine=machines/$MACHINE --out-link out-links/$MACHINE
```

## Flashing
```bash
# set correct path for SD card
export SD_CARD=/dev/sda
# inflate image and write to SD card
sudo sh -c "zstd -dcf out-links/$MACHINE/sd-image/*.img.zst | dd status=progress bs=64k iflag=fullblock oflag=direct of=$SD_CARD && sync && eject $SD_CARD"
```
