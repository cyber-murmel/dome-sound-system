{ ... }:
{
  users.extraUsers.nixos.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1.... user@host"
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
}
