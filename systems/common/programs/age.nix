{ pkgs, config, lib, ... }:
{
  environment.systemPackages = with pkgs; [
    age
    passage
  ]
  ++ lib.optional config.security.tpm2.enable pkgs.age-plugin-tpm;
}
