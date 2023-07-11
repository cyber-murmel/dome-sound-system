{ ... }:

let
  musicMountPoint = "/music";
in
{
  users.extraUsers.nixos.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1...."
  ];

  networking = {
    hostName = "nixos";

    wireless = {
      networks = {
        "SSID" = {
          psk = "PASSWORD";
        };
      };
    };
  };

  # activate this to mount a partition with the label MUSIC as the mpd library
  # this way you can put the music for example on an USB stick

  # fileSystems = {
  #   "${musicMountPoint}" = {
  #     label = "MUSIC";
  #     depends = [
  #       "/"
  #     ];
  #   };
  # };
  # services.mpd.musicDirectory = "${musicMountPoint}";
}
