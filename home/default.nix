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
  # Imports conditionnels (pattern vdemeester adapté)
  imports = [
    # Shell toujours présent
    ./common/shell
    # TODO: À terme, restaurer: inputs.niri.homeModules.niri quand inputs disponibles
  ]
  # Desktop si défini
  ++ lib.optional (builtins.isString desktop) ./common/desktop
  # Utilisateur spécifique si existe (TODO: créer common/users/${username})
  # ++ lib.optional (builtins.pathExists (./. + "/common/users/${username}")) ./common/users/${username}
  # Import autres modules communs
  ++ [
    ./common/dev
    ./common/edf-sf  
    ./common/profiles
    ./common/services
    ./common/tools
  ]
  # Machine-specific home config si existe (TODO: créer)
  # ++ lib.optional (builtins.pathExists (../systems/. + "/${hostname}/home.nix")) ../systems/${hostname}/home.nix
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
      # Nos overlays (TODO: développer)
      # outputs.overlays.additions
      # outputs.overlays.modifications
      
      # Overlays externes (disponibles via inputs)
      inputs.emacs-overlay.overlays.default
      # TODO: ajouter autres overlays quand inputs étendus
      
      # Overlays de compatibilité/migration
      (_: prev: {
        # TODO: packages de migration si nécessaire
      })
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