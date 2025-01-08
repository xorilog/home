{ config, lib, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf mkMerge mkOption types;
  cfg = config.modules.hardware.tpm;
in
{
  options = {
    modules.hardware.tpm = {
      enable = mkEnableOption "Enable tpm profile";
      # See systems/modules/core/nix.nix for xophe groups
      #u2f = mkOption {
      #  default = true;
      #  description = "wether to enable auth with yubkeys through pam using u2f";
      #  type = types.bool;
      #};
      #autoLock = mkOption {
      #  default = true;
      #  description = "wether to enable session lock when the yubikey is removed";
      #  type = types.bool;
      #};
    };
  };
  config = mkIf cfg.enable (mkMerge [
    {
      security = {
        tpm2 = {
          enable = true;
          pkcs11.enable = true; # expose /run/current-system/sw/lib/libtpm2_pkcs11.so
          tctiEnvironment.enable = true; # TPM2TOOLS_TCTI and TPM2_PKCS11_TCTI env variables

        };
      };
    }
  ]);
}
