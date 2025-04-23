{ config, lib, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf mkMerge mkOption types;
  cfg = config.modules.hardware.yubikey;
in
{
  options = {
    modules.hardware.yubikey = {
      enable = mkEnableOption "Enable yubikey profile";
      agent = mkOption {
        default = true;
        description = "wether to enable yubikey-agent";
        type = types.bool;
      };
      u2f = mkOption {
        default = true;
        description = "wether to enable auth with yubkeys through pam using u2f";
        type = types.bool;
      };
      autoLock = mkOption {
        default = true;
        description = "wether to enable session lock when the yubikey is removed";
        type = types.bool;
      };
    };
  };
  config = mkIf cfg.enable (mkMerge [
    {
      environment = {
        systemPackages = with pkgs; [
          yubico-piv-tool
          yubikey-personalization
          yubikey-manager
          age-plugin-yubikey
        ];
      };
      services = {
        pcscd.enable = true;
        udev = {
          packages = with pkgs; [ yubikey-personalization ];
        };
      };
    }
    (mkIf cfg.autoLock {
      services = {
        udev = {
          extraRules = ''
            # Yubico YubiKey
            KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1050", ATTRS{idProduct}=="0113|0114|0115|0116|0120|0402|0403|0406|0407|0410", TAG+="uaccess", MODE="0660", GROUP="wheel"
            # ACTION=="remove", ENV{ID_VENDOR_ID}=="1050", ENV{ID_MODEL_ID}=="0113|0114|0115|0116|0120|0402|0403|0406|0407|0410", RUN+="${pkgs.systemd}/bin/loginctl lock-sessions"
          '';
        };
      };
    })
    (mkIf config.modules.desktop.enable {
      environment.systemPackages = with pkgs; [
        yubioath-flutter
      ];
      programs.yubikey-touch-detector = {
        enable = true;
      };
    })
    (mkIf cfg.u2f {
      security.pam.u2f = {
        enable = true;
        origin = "pam://yubi";
        authFile = pkgs.writeText "u2f-mappings" (lib.ConcatStrings [
          "xophe"
          ":qZVkmweCLfyquBCKkbv9cPXfXp8Bhp+jd19pqN6D45Bz7AnKnhOnF3Di1gocEusNOXZcym/KHi+33lyBFQ6GrA==,3W+0y3HBSUrrU+/y6ON8TLYcuJdg9EvjHlhku/bt23UEFYIGL3JipPtxO3KQyuZQXrLflXglMKDAgYbJhpp0Hw==,es256,+presence" # yubikey-5-usbc-989
          # yubikey-5-usba-955
          # yubikey-5-usbc-jt-892
          # TODO: add other yubikeys (https://nixos.wiki/wiki/Yubikey)
          # 1. Connect your Yubikey
          # 2. Create an authorization mapping file for your user. The authorization mapping file is like `~/.ssh/known_hosts` but for Yubikeys.
          # nix-shell -p pam_u2f
          # mkdir -p ~/.config/Yubico
          # pamu2fcfg > ~/.config/Yubico/u2f_keys
          # add another yubikey (optional): pamu2fcfg -n >> ~/.config/Yubico/u2f_keys
        ]);
      };
    })
    (mkIf cfg.agent {
      programs.gnupg.agent.pinentryPackage = pkgs.pinentry-gnome3;
      services.yubikey-agent.enable = true;
    })
  ]);
}
