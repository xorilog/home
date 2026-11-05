{ config, pkgs, ... }:

{
  gtk = {
    enable = true;
    iconTheme = {
      name = "Arc";
      package = pkgs.arc-icon-theme;
    };
    theme = {
      name = "Arc-Darker";
      package = pkgs.arc-theme;
    };
    # keep pre-26.05 behavior (gtk4 default changed to null)
    gtk4.theme = config.gtk.theme;
  };
}
