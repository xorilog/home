{ lib, desktop, ... }:
let
  inherit (lib) optionals;
in
{
  imports = [
    ./base.nix
    #./i3.nix
    ## TODO: reactivate this later but it cannot be imported when i3 is imported as well.
    ##./sway.nix
    #./xorg.nix
  ]
  ++ optionals (desktop == "i3") [ ./i3.nix ./xorg.nix ]
  ++ optionals (desktop == "sway") [ ./sway.nix ];
}
