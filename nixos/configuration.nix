{ config, pkgs, lib, ... }:
{
  imports = [
    ./minification.nix
    ./audio
    ./audio/iqaudio-dac.nix
    ./bluetooth
  ]
  ++ lib.optionals (builtins.pathExists ./hardware-configuration.nix) [ ./hardware-configuration.nix ]
  ++ lib.optionals (builtins.pathExists ./custom.nix) [ ./custom.nix ];

  # boot.loader.grub.enable = false;

  environment.systemPackages = with pkgs; [
    screen
    vim
    htop
    bottom
    # git
    evtest
    (python3.withPackages (ps: with ps;[
      evdev
    ]))
    libraspberrypi
  ];

  users = {
    extraUsers.nixos = {
      isNormalUser = true;
      initialPassword = "nixos";
      extraGroups = [ "wheel" "input" "plugdev" ];
    };
  };

  networking.wireless = {
    enable = true;
    userControlled.enable = true;
  };

  services = {
    #getty.autologinUser = "nixos";
    openssh = {
      enable = true;
      settings = {
        # enable password authentication if no public key is set
        PasswordAuthentication = if config.users.extraUsers.nixos.openssh.authorizedKeys.keys == [ ] then true else false;
        PermitRootLogin = "no";
      };
    };
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
    };
  };

  system.stateVersion = "nixos-23.05";
}
