{ pkgs, ... }:

{
  imports = [
    ./ai.nix
    ./go.nix
    ./nix.nix
    ./python.nix
    ./pre-commit.nix
  ];

  home.extraOutputsToInstall = [
    "doc"
    "info"
    "devdoc"
  ];

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
    code-cursor
    bash-language-server
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
}
