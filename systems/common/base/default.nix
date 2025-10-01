{
  imports = [
    ./base.nix
    ./boot.nix
    ./config.nix
    ./development.nix
    ./home.nix
    ./i18n.nix
    ../programs
  ];

  boot = {
    tmp = {
      cleanOnBoot = true;
    };
  };

  # Only keep the last 500MiB of systemd journal.
  services.journald.extraConfig = "SystemMaxUse=500M";
}
