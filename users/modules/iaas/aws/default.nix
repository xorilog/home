{ pkgs, nixosConfig, ... }:

{
  imports = [
    # autorandr
    # xophe ./finances.nix
    # xophe ./next.nix
    # xophe ./keyboard.nix
    # xophe ./spotify.nix
    #./firefox.nix
    #./gtk.nix
    #./mpv.nix
    # ./i3.nix
    # ./mpd.nix
    # ./redshift.nix
    # ./xsession.nix
  ];
  home.packages = with pkgs; [
    aws-vault
    aws-iam-authenticator
    awscli2

    pass
  ]; # ++ lib.optionals nixosConfig.profiles.desktop.i3.enable [ pkgs.brave ];

  programs.zsh.sessionVariables = {
    AWS_VAULT_BACKEND = "pass";
    AWS_VAULT_PASS_PREFIX = "vault";
    AWS_VAULT_PASS_PASSWORD_STORE_DIR = ''''${HOME}/sync/password-store'';
  };

}
