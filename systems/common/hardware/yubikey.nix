# Yubikey hardware configuration (pattern vdemeester)
{ config, lib, pkgs, desktop, ... }:
{
  # Yubikey packages
  environment.systemPackages = with pkgs; [
    yubico-piv-tool
    yubikey-personalization
    yubikey-manager
    age-plugin-yubikey
  ] ++ lib.optionals (builtins.isString desktop) [
    yubioath-flutter
  ];

  services = {
    pcscd.enable = true;
    udev = {
      packages = with pkgs; [ yubikey-personalization ];
      extraRules = ''
        # Yubico YubiKey
        KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1050", ATTRS{idProduct}=="0113|0114|0115|0116|0120|0402|0403|0406|0407|0410", TAG+="uaccess", MODE="0660", GROUP="wheel"
      '';
    };
    yubikey-agent.enable = true;
  };

  # Desktop programs
  programs = {
    gnupg.agent.pinentryPackage = pkgs.pinentry-gnome3;
  } // lib.optionalAttrs (builtins.isString desktop) {
    yubikey-touch-detector.enable = true;
  };

  # U2F authentication (updated options)
  security.pam.u2f = {
    enable = true;
    settings = {
      origin = "pam://yubi";
      authfile = pkgs.writeText "u2f-mappings" (lib.concatStrings [
        "xophe"
        ":qZVkmweCLfyquBCKkbv9cPXfXp8Bhp+jd19pqN6D45Bz7AnKnhOnF3Di1gocEusNOXZcym/KHi+33lyBFQ6GrA==,3W+0y3HBSUrrU+/y6ON8TLYcuJdg9EvjHlhku/bt23UEFYIGL3JipPtxO3KQyuZQXrLflXglMKDAgYbJhpp0Hw==,es256,+presence"
      ]);
    };
  };
}
