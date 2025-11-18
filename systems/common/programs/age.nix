{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
{
  environment.systemPackages =
    with pkgs;
    [
      age
      passage
      inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default # agenix CLI
    ]
    ++ lib.optional config.security.tpm2.enable pkgs.age-plugin-tpm;
}
