{ config, pkgs, lib, ... }:
{
  environment.systemPackages = with pkgs; [
    # (cwiid.overrideAttrs (oldAttrs: {
    #   # needed for cross compilation
    #   nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [ bintools-unwrapped bison flex ];
    # }))
  ];

  hardware.bluetooth.enable = true;

  systemd.services.btattach = {
    before = [ "bluetooth.service" ];
    after = [ "dev-ttyAMA0.device" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.bluez}/bin/btattach -B /dev/ttyAMA0 -P bcm -S 3000000";
    };
  };
}
