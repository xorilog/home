# SSH configuration (pattern vdemeester)
{
  config,
  lib,
  pkgs,
  ...
}:
{
  services = {
    openssh = {
      enable = true;
      startWhenNeeded = false;
      settings = {
        X11Forwarding = false;
      };
      extraConfig = ''
        StreamLocalBindUnlink yes
      '';
    };
    sshguard.enable = true;
  };
  programs.mosh.enable = true;
}
