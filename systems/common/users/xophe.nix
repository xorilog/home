{
  pkgs,
  lib,
  config,
  desktop,
  hostname,
  outputs,
  stateVersion,
  inputs,
  globals,
  libx,
  ...
}:
let
  ifExists = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in
{
  users.users.xophe = {
    description = "Christophe Boucharlat";
    createHome = true;
    uid = 1000;
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [
      "wheel"
      "users"
    ]
    ++ lib.optionals (builtins.isString desktop) [
      "networkmanager"
      "audio"
      "video"
    ]
    ++ ifExists [
      "buildkit"
      "docker"
      "libvirt"
      "libvirtd"
      "lp"
      "messagebus"
      "nginx"
      "plugdev"
      "scanner"
      "tss"
      "vboxusers"
    ];
    subUidRanges = [
      {
        startUid = 100000;
        count = 65536;
      }
    ];
    subGidRanges = [
      {
        startGid = 100000;
        count = 65536;
      }
    ];
    initialPassword = "changeMe";
    openssh.authorizedKeys.keys = globals.ssh.xophe;
    packages = [ pkgs.home-manager ];
  };

  nix = {
    settings = {
      trusted-users = [ "xophe" ];
    };
  };

  security = {
    pam = {
      services = {
        # https://github.com/NixOS/nixpkgs/issues/401891#issuecomment-2831813778
        i3lock = {
          enable = true;
        };
      };
      # Nix will hit the stack limit when using `nixFlakes`.
      loginLimits = [
        {
          domain = config.users.users.xophe.name;
          item = "stack";
          type = "-";
          value = "unlimited";
        }
      ];
    };
  };

  # Enable user units to persist after sessions end.
  system.activationScripts.loginctl-enable-linger-xophe = lib.stringAfter [ "users" ] ''
    ${pkgs.systemd}/bin/loginctl enable-linger ${config.users.users.xophe.name}
  '';

  # To use nixos config in home-manager configuration, use the nixosConfig attr.
  # This make it possible to import the whole configuration, and let each module
  # load their own.
  # FIXME(vdemeester) using nixosConfig, we can get the NixOS configuration from
  # the home-manager configuration. This should help play around the conditions
  # inside each "home-manager" modules instead of here.
  # Configuration home-manager pour xophe
  # Previous xophe way to do it.
  #home-manager.users.xophe = lib.mkMerge [
  #  (import ../../../home/common)
  #  # EDF-SF configuration can be enabled selectively
  #  # (import ../../../home/common/edf-sf)
  #];
  # Do I user home-manager nixosModule *or* home-manager on its own
  home-manager.users.xophe = import ../../../home/default.nix {
    inherit
      config
      pkgs
      lib
      hostname
      desktop
      globals
      outputs
      inputs
      stateVersion
      libx
      ;
    username = "xophe";
  };
  # This is a workaround for not seemingly being able to set $EDITOR in home-manager
  environment.sessionVariables = {
    EDITOR = "nvim";
  };
}
