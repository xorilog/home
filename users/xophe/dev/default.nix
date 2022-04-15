{ pkgs, ... }:

{
  imports = [
    ./go.nix
    ./nix.nix
    ./python.nix
    ./pre-commit.nix
  ];

  home.extraOutputsToInstall = [ "doc" "info" "devdoc" ];

  home.packages = with pkgs; [
    binutils
    cmake
    fswatch
    gnumake
    jq
    yq-go
    gron
    shfmt
    httpie
  ];

  home.file.".ignore".text = ''
    *.swp
    *~
    **/VENDOR-LICENSE
  '';

  home.file.gdbinit = {
    target = ".gdbinit";
    text = ''
      set auto-load safe-path /
    '';
  };

  xdg.configFile."nr/dev" = {
    text = builtins.toJSON [
      { cmd = "lnav"; }
      { cmd = "miniserve"; }
      { cmd = "licensor"; }
      { cmd = "yamllint"; pkg = "python37Packages.yamllint"; }
      { cmd = "http"; pkg = "httpie"; }
    ];
    onChange = "${pkgs.my.nr}/bin/nr dev";
  };

}
