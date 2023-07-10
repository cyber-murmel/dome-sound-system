{ config, pkgs, lib, ... }:

{
  sound.enable = true;

  security.rtkit.enable = true;

  hardware.pulseaudio = {
    enable = true;
    systemWide = true;
    package = pkgs.pulseaudioFull.override {
      remoteControlSupport = false;
    };
    # package = pkgs.pulseaudio.override {
    #   jackaudioSupport = true;
    #   airtunesSupport = true;
    #   alsaSupport = true;
    #   bluetoothSupport = true;
    #   advancedBluetoothCodecs = true;
    #   zeroconfSupport = true;
    # };
    tcp = {
      enable = true;
      anonymousClients.allowAll = true;
    };
    zeroconf.publish.enable = true;
    daemon.config = {
      realtime-scheduling = "yes";
      default-fragments = 32;
    };

    # turn timer-based scheduling off
    configFile = pkgs.runCommand "default.pa" { } ''
      sed 's/module-udev-detect$/module-udev-detect tsched=0/' \
        ${pkgs.pulseaudio}/etc/pulse/default.pa > $out
    '';
  };
  users.extraUsers.pulse.extraGroups = [ "rtkit" ];

  services.shairport-sync = {
    group = "pulse-access";
    enable = true;
  };

  nixpkgs.overlays = with pkgs;[
    (final: prev: {
      # https://github.com/NixOS/nixpkgs/pull/242350
      shairport-sync = prev.shairport-sync.overrideAttrs (old: {
        buildInputs = old.buildInputs ++ [
          # pkgs.binutils
        ];
        nativeBuildInputs = old.nativeBuildInputs ++ [
          glib
          # pkgs.stdenv.cc
        ];
        makeFlags = [
          # Workaround for https://github.com/mikebrady/shairport-sync/issues/1705
          "AR=${stdenv.cc.bintools.targetPrefix}ar"
        ];
        strictDeps = true;
      });
    })
  ];

  # uncomment to use on board audio output
  # boot.loader.raspberryPi.firmwareConfig = ''
  #   dtparam=audio=on
  # '';

  users.extraUsers.nixos.extraGroups = [ "audio" "pulse-access" ];

  environment.systemPackages = with pkgs; [
    pulsemixer
  ];
}
