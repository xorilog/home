{ config, username, ... }:
{
  home.homeDirectory = "/Users/${username}";
}
