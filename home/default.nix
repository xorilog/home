{
  config,
  desktop ? null,
  hostname,
  lib,
  outputs,
  stateVersion,
  username,
  inputs,
  globals ? { },
  libx ? { },
  pkgs,
  ...
}:
{
  imports = [
    # Shell toujours présent
    ./common/shell
    # TODO: À terme, restaurer: inputs.niri.homeModules.niri quand inputs disponibles

    # TODO: move this somewhere else during the way too many default.nix file removal.
    # Modules communs
    ./common/services
  ]
  # Desktop si défini
  ++ lib.optional (builtins.isString desktop) ./common/desktop
  ++ lib.optional (builtins.pathExists (./. + "/common/users/${username}")) ./common/users/${username}
  ++ lib.optional (
    builtins.hasAttr "${hostname}" globals.machines
    && libx.hasSyncthingFolders globals.machines."${hostname}"
  ) ./common/services/syncthing.nix
  ++ lib.optional (builtins.pathExists (
    ../systems/. + "/${hostname}/home.nix"
  )) ../systems/${hostname}/home.nix
  ++ lib.optional pkgs.stdenv.hostPlatform.isDarwin (../systems-darwin/${hostname}/home.nix);

  home = {
    inherit username stateVersion;
    homeDirectory =
      if pkgs.stdenv.hostPlatform.isDarwin then "/Users/${username}" else "/home/${username}";
  };

  nix = {
    package = pkgs.nix;
    settings =
      if pkgs.stdenv.hostPlatform.isDarwin then
        {
          download-buffer-size = 524288000; # 500 MiB
          experimental-features = [
            "nix-command"
            "flakes"
          ];
          use-xdg-base-directories = true;
        }
      else
        { };
  };

  nixpkgs = {
    overlays = [
      # Our own flake exports (from overlays and pkgs dir)
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

      # And from other flakes
      #inputs.agenix.overlays.default
      inputs.ghostty.overlays.default or (_: _: { })
      inputs.claude-desktop.overlays.default or (_: _: { })
    ];
    config = {
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };
}
