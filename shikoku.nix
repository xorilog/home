{ pkgs, ... }:

{
  imports = [
    ./desktop.nix
    ./devops.nix
    ./openshift.nix
  ];
  profiles.desktop.enable = true;
  profiles.gaming.enable = true;
  profiles.dev = {
    go.enable = true;
    haskell.enable = true;
    java = { enable = true; idea = true; };
    js.enable = true;
    python.enable = true;
    rust.enable = true;
  };
  profiles.containers = {
    enable = true;
    docker = true;
  };
  programs.vscode.enable = true;
  home.packages = with pkgs; [
    google-chrome
    obs-studio # screencast
    mattermost-desktop
    slack
    virtmanager
    zoom-us
  ];
  services.shairport-sync.enable = true;
}
