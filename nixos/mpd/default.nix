{ config, pkgs, lib, ... }:

{
  imports = [
    ./mympd.nix
  ];

  services = {
    mpd = {
      enable = true;
      # dataDir = "/var/lib/mpd";
      # musicDirectory = "/var/lib/mpd";
      extraConfig = ''
        audio_output {
          type "pulse"
          name "PulseAudio" # this can be whatever you want
        }
      '';

      # Optional:
      network.listenAddress = "any"; # if you want to allow non-localhost connections
      # startWhenNeeded = true; # systemd feature: only start MPD service upon connection to its socket
    };
  };

  networking.firewall.allowedTCPPorts = [ config.services.mpd.network.port ];

  users.extraUsers.nixos.extraGroups = [ config.services.mpd.group ];
  users.extraUsers.mpd.extraGroups = [ "pulse-access" ];

  environment = {
    variables = {
      MPD_MUSIC_DIR = config.services.mpd.musicDirectory;
    };
  };
}
