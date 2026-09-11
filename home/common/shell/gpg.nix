{
  pkgs,
  config,
  lib,
  ...
}:

{
  home.packages = with pkgs; [ gnupg ];

  # Set GNUPGHOME to use XDG configuration directory (home-manager level)
  # Correct version of this should be "~/.config/gnupg" but for now it is at ~/.gnupg.
  # TODO: fix this when i know how to auto create the GNUPGHOME directory.
  home.sessionVariables = {
    # wanted:
    #GNUPGHOME = "${config.xdg.configHome}/gnupg";
    # Auto created:
    GNUPGHOME = "${config.home.homeDirectory}/.gnupg";
  };

  services = {
    gpg-agent = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
      enable = true;
      enableSshSupport = true;
      enableExtraSocket = true;
      defaultCacheTtlSsh = 7200;
      # pinEntryFlavor = "gtk2";
    };
  };
}
