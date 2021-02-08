{ config, inputs, lib, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf mkDefault mkOverride;
  cfg = config.modules.base;
in
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];
  options = {
    modules.base = {
      enable = mkEnableOption "base configuration";
    };
  };
  config = mkIf cfg.enable {

    boot = {
      # Enable running aarch64 binaries using qemu.
      binfmt.emulatedSystems = [ "aarch64-linux" ];

      # Clean temporary directory on boot
      cleanTmpDir = true;

      loader = {
        # Use systemd-boot by default, can be overridden by configurations
        systemd-boot.enable = true;

        # Make memtest available as a boot option.
        grub.memtest86.enable = true;
        systemd-boot.memtest86.enable = true;
      };
    };

    console = {
      keyMap = "us";
      font = "Lat2-Terminus16";
    };

    environment = {
      # System packages to install, those are the absolute minimum packages required
      systemPackages = with pkgs; [
        file
        htop
        iotop
        lsof
        netcat
        psmisc
        pv
        wget
      ];
    };

    # Home manager default configuration
    home-manager = {
      useUserPackages = true;
      useGlobalPkgs = true;
    };

    i18n.defaultLocale = "en_US.UTF-8";

    # Make sure we never remove SSH_AUTH_SOCK when reseting env through sudo
    security.sudo.extraConfig = ''
      Defaults env_keep += SSH_AUTH_SOCK
    '';
    # `nix-daemon` will hit the stack limit when using `nixFlakes`.
    systemd.services.nix-daemon.serviceConfig."LimitSTACK" = "infinity";
    # Setup a *mailer* in case of failure in systemd
    systemd.services."status-email-root@" = {
      description = "status email for %i to christophe";
      serviceConfig = {
        Type = "oneshot";
        ExecStart = ''
          ${pkgs.systemd-email}/bin/systemd-email home-nix@boucharlat.info %i
        '';
        User = "root";
        Environment = "PATH=/run/current-system/sw/bin";
      };
    };
  };
}
