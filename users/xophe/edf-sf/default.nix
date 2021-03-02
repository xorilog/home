{ pkgs, ... }:

{
  imports = [
  ];

  home.packages = with pkgs; [
    mattermost-desktop
    thunderbird-78
    keepassxc
  ];
}
