{ pkgs, nixosConfig, ... }:

{
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
