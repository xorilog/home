{
  config,
  pkgs,
  ...
}:
{
  # TODO: building this file is in progress.
  imports = [
    ../../home/common/dev/containers.nix
    ../../home/common/dev/default.nix

    ../../systems/edfsf/home.nix
  ];

  home.packages = with pkgs; [
  ];
}
