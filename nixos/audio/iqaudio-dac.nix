{ config, pkgs, lib, ... }:

{
  boot.loader.raspberryPi.firmwareConfig = ''
    dtoverlay=iqaudio-dacplus,auto_mute_amp,unmute_amp
  '';

  hardware.pulseaudio.extraConfig = "set-default-sink 1";
}
