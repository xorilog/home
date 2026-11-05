# Avahi configuration (pattern vdemeester)
{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) versionOlder;
  stable = versionOlder config.system.nixos.release "24.05";
in
{
  services.avahi = {
    enable = true;
    settings = {
      server = {
        use-ipv4 = true;
        use-ipv6 = true;
      };
      publish = {
        disable-publishing = false;
        disable-user-service-publishing = false;
        publish-addresses = true;
      };
    };
    openFirewall = true;
  }
  // (
    if stable then
      {
        nssmdns = true;
      }
    else
      {
        nssmdns4 = true;
      }
  );
}
