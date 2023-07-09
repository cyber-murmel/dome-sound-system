{ config, pkgs, lib, ... }:
{
  # cross compile
  # nixpkgs.crossSystem = lib.systems.elaborate lib.systems.examples.aarch64-multiplatform;
  # nixpkgs.crossSystem = lib.systems.elaborate lib.systems.examples.armv7l-hf-multiplatform;
  nixpkgs.crossSystem = lib.systems.elaborate lib.systems.examples.raspberryPi;

  # # emulate
  # nixpkgs.system = "aarch64-linux";

  imports = [
    <nixpkgs/nixos/modules/profiles/base.nix>
    <nixpkgs/nixos/modules/installer/sd-card/sd-image.nix>
  ];

  sdImage = {
    imageBaseName = "nixos-raspberry-3";
    populateRootCommands = "";
    populateFirmwareCommands = with config.system.build; ''
      ${installBootLoader} ${toplevel} -d ./firmware
      cp -r ${pkgs.raspberrypifw}/share/raspberrypi/boot/overlays/ ./firmware/
    '';
    firmwareSize = 128;
  };
}
