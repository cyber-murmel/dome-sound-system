{ config, pkgs, lib, ... }:

let
  name = "mympd";
  user = "${name}";
  group = "${name}";
in
{
  systemd.services.mypmd = {
    description = "A standalone and mobile friendly web mpd client with a tiny footprint and advanced features";

    after = [ "network-online.target" ];
    # The default method for starting a unit by default at boot time
    # is to set this option to ["multi-user.target"] for system services.
    wantedBy = [ "multi-user.target" ];

    preStart =
      ''
        set -euo pipefail

        ${config.security.wrapperDir}/mympd -c
      '';

    serviceConfig = {
      User = "${user}";
      StateDirectory = [
        "${name}"
      ];
      ExecStart = ''
        ${config.security.wrapperDir}/mympd
      '';
    };
  };

  users = {
    groups."${group}" = { };
    users."${user}" = {
      isSystemUser = true;
      group = "${group}";
      home = "/var/lib/${name}";
    };
  };

  security.wrappers.mympd = {
    source = "${pkgs.mympd}/bin/mympd";
    owner = "root";
    group = "root";
    permissions = "u+rx,g+rx,o+rx";
    # allow binding to port 80 and 443
    capabilities = "cap_net_bind_service+ep";
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
