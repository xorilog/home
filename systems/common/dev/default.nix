# Development base configuration (pattern vdemeester)
{
  config,
  lib,
  pkgs,
  ...
}:
{
  # Import shell tools directly
  imports = [
    ../shell/direnv.nix
    ../shell/git.nix
    ../shell/tmux.nix
    ../editors/vim.nix
  ];

  # Development packages
  environment.systemPackages = with pkgs; [
    grc
    ripgrep
    gnumake
  ];
}
