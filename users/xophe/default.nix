{ config, lib, pkgs, ... }:
with lib;
let
  hasConfigVirtualizationContainers = builtins.hasAttr "containers" config.virtualisation;
  isContainersEnabled = if hasConfigVirtualizationContainers then config.virtualisation.containers.enable else false;
in
{
  warnings = if (versionAtLeast config.system.nixos.release "21.11") then [ ] else [ "NixOS release: ${config.system.nixos.release}" ];
  users.users.xophe = {
    createHome = true;
    uid = 1000;
    description = "Christophe Boucharlat";
    extraGroups = [ "wheel" "input" ]
      ++ optionals config.profiles.desktop.enable [ "audio" "video" ]
      ++ optionals config.profiles.scanning.enable [ "lp" "scanner" ]
      ++ optionals config.networking.networkmanager.enable [ "networkmanager" ]
      ++ optionals config.virtualisation.docker.enable [ "docker" ]
      ++ optionals config.virtualisation.buildkitd.enable [ "buildkit" ]
      ++ optionals config.modules.hardware.tpm.enable [ "tss" ] # tss group has access to TPM devices
      ++ optionals config.modules.virtualisation.libvirt.enable [ "libvirtd" "vboxusers" ];
    shell = mkIf config.programs.zsh.enable pkgs.zsh;
    isNormalUser = true;
    initialPassword = "changeMe";
    subUidRanges = [{ startUid = 100000; count = 65536; }];
    subGidRanges = [{ startGid = 100000; count = 65536; }];
  };

  nix = {
    settings = {
      trusted-users = [ "xophe" ];
    };
  };

  security = {
    pam = {
      # Nix will hit the stack limit when using `nixFlakes`.
      loginLimits = [
        { domain = config.users.users.xophe.name; item = "stack"; type = "-"; value = "unlimited"; }
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
  home-manager.users.xophe = lib.mkMerge
    (
      [
        (import ./core)
        # TODO: Xophe to move elsewhere
        (import ../modules/iaas/aws)
      ]
      ++ optionals config.modules.dev.enable [
        (import ./dev)
      ]
      ++ optionals config.modules.dev.containers.enable [
        (import ./containers)
      ]
      ++ optionals config.profiles.desktop.enable [ (import ./desktop) ]
      ++ optionals config.profiles.desktop.gnome.enable [ (import ./desktop/gnome.nix) ]
      # ++ optionals config.profiles.desktop.i3.enable [ (import ./desktop/i3.nix) ]
      # TODO: (Xophe) i need to see where to put it
      ++ optionals config.virtualisation.docker.enable [
        {
          home.packages = with pkgs; [ docker docker-compose ];
        }
      ]
      #++ optionals config.profiles.kubernetes.enable [ (import ./containers/kubernetes.nix) ]
      ++ optionals config.profiles.edf-sf.enable [
        (import ./edf-sf)
      ]
    );
}
