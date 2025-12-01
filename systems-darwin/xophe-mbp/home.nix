{
  config,
  username,
  pkgs,
  ...
}:
{
  home.homeDirectory = "/Users/${username}";
  home.packages = with pkgs; [
    spotify
  ];
}
