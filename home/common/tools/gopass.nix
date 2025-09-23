{ pkgs, ... }:
{
  home.packages = with pkgs; [
    gopass
  ];

  # doc https://github.com/gopasspw/gopass/blob/master/docs/features.md#initializing-a-password-store
  # init with gopass init --path ~/sync/password-store B151572DE8FADB71
  programs.bash.sessionVariables = {
    PASSWORD_STORE_DIR = ''''${HOME}/sync/password-store'';
  };

  programs.bash.shellAliases = {
    "pass" = "gopass";
  };

  programs.zsh.shellAliases = {
    "pass" = "gopass";
  };
}
