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
        PasswordAuthentication = false;
        PermitRootLogin = "no";
      };
      extraConfig = ''
        StreamLocalBindUnlink yes
      '';
    };
    sshguard.enable = true;
  };
  programs.mosh.enable = true;
  security.pam.sshAgentAuth.enable = true;
}
