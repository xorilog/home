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
  # Imports conditionnels (pattern vdemeester optimisé)
  imports = [
    # Shell toujours présent
    ./common/shell
    # TODO: À terme, restaurer: inputs.niri.homeModules.niri quand inputs disponibles
  ]
  # Desktop si défini
  ++ lib.optional (builtins.isString desktop) ./common/desktop
  # Utilisateur spécifique si existe  
  ++ lib.optional (builtins.pathExists (./. + "/common/users/${username}")) ./common/users/${username}
  # Import autres modules communs
  ++ [
    ./common/dev
    ./common/edf-sf  
    ./common/profiles
    ./common/services
    ./common/tools
  ]
  # Syncthing conditionnel basé sur globals
  ++ lib.optional (
    builtins.hasAttr "${hostname}" globals.machines
    && libx.hasSyncthingFolders globals.machines."${hostname}"
  ) ./common/services/syncthing.nix
  # Machine-specific home config si existe
  ++ lib.optional (builtins.pathExists (../systems/. + "/${hostname}/home.nix")) ../systems/${hostname}/home.nix
  ;

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

  # Configuration nixpkgs avec overlays
  nixpkgs = {
    overlays = [
      # Nos overlays (système avancé)
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
      
      # Overlays externes (disponibles via inputs)
      inputs.emacs-overlay.overlays.default
      
      # Overlays externes à intégrer
      inputs.ghostty.overlays.default or (_: _: {})
      inputs.claude-desktop.overlays.default or (_: _: {})
    ];
    config = {
      allowUnfree = true;
      # Workaround pour home-manager
      allowUnfreePredicate = _: true;
    };
  };

  # Programme home-manager
  programs.home-manager.enable = true;
}