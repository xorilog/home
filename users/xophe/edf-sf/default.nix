{ pkgs, ... }:

{
  home.packages = with pkgs; [
    mattermost-desktop
    thunderbird
    keepassxc
  ];
}
