{
  services = {
    redshift = {
      enable = true;
      settings.redshift = {
        brightness-day = "1";
        brightness-night = "0.9";
      };
      latitude = "48.3";
      longitude = "7.5";
      tray = true;
    };
  };
}
