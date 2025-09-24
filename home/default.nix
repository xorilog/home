{
  config,
  desktop ? null,
  hostname,
  lib,
  outputs,
  stateVersion,
  username,
  inputs,
  globals ? {},
  libx ? {},
  ...
}:
{
  imports = [
    # Shell toujours présent
    ./common/shell
    # TODO: À terme, restaurer: inputs.niri.homeModules.niri quand inputs disponibles

    # Modules communs
    ./common/dev
    ./common/edf-sf
    ./common/profiles
    ./common/services
    ./common/tools
  ]
  # Desktop si défini
  ++ lib.optional (builtins.isString desktop) ./common/desktop
  # Version dynamique gardée pour examination future
  ++ lib.optional (builtins.pathExists (./. + "/common/users/${username}")) ./common/users/${username}
  # Utilisateur spécifique - hardcodé pour xophe pour éviter infinite recursion
  #++ lib.optional (builtins.pathExists ./common/users/xophe.nix) ./common/users/xophe.nix
  # Syncthing conditionnel basé sur globals
  ++ lib.optional (
    builtins.hasAttr "${hostname}" globals.machines
    && libx.hasSyncthingFolders globals.machines."${hostname}"
  ) ./common/services/syncthing.nix
  # Machine-specific home config si existe
  ++ lib.optional (builtins.pathExists (../systems/. + "/${hostname}/home.nix")) ../systems/${hostname}/home.nix;

  # Configuration home de base
  home = {
    inherit username stateVersion;
    homeDirectory = "/home/${username}";
  };

  # Configuration Nix pour home-manager
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    use-xdg-base-directories = true;
  };

  # Configuration nixpkgs avec overlays - désactivé car useGlobalPkgs = true
  # nixpkgs = {
  #   overlays = [
  #     # Nos overlays (système avancé)
  #     outputs.overlays.additions
  #     outputs.overlays.modifications
  #     outputs.overlays.unstable-packages
  #
  #     # Overlays externes (disponibles via inputs)
  #     # TODO: remove emacs stuff
  #     inputs.emacs-overlay.overlays.default
  #
  #     # Overlays externes à intégrer
  #     inputs.ghostty.overlays.default or (_: _: {})
  #     inputs.claude-desktop.overlays.default or (_: _: {})
  #   ];
  #   config = {
  #     allowUnfree = true;
  #     # Workaround pour home-manager
  #     allowUnfreePredicate = _: true;
  #   };
  # };

  # Programme home-manager
  programs.home-manager.enable = true;
}
