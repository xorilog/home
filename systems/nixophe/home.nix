{ pkgs, ... }:
{
  # TODO: building this file is in progress.
  imports = [
    ../../home/common/dev/containers.nix

    ../edfsf/home.nix
  ];

  home.packages = with pkgs; [
    #chromium
    spotify
    #easyeffects
    #thunderbird
    #nautilus

    #gmailctl

    # lisp
    #roswell
    #sbcl
  ];

  # systemd.user.services.battery-monitor = {
  #   Unit = {
  #     Description = "battery monitory service";
  #     After = "graphical-session.target";
  #     PartOf = "graphical-session.target";
  #
  #     # Avoid killing the Emacs session, which may be full of
  #     # unsaved buffers.
  #     X-RestartIfChanged = false;
  #   };
  #   Service = {
  #     ExecStart = ''
  #       ${pkgs.battery-monitor}/bin/battery-monitor
  #     '';
  #     Restart = "on-failure";
  #   };
  #   Install = {
  #     WantedBy = [ "graphical-session.target" ];
  #   };
  # };
}
