{ pkgs, ... }:

{
  home.extraOutputsToInstall = [
    "doc"
    "info"
    "devdoc"
  ];

  home.packages = with pkgs; [
    jq
    ijq # interactive jq
    yq-go

    binutils
    moreutils
    gnumake

    # shell tooling
    shellcheck
    shfmt
    httpie

    # old
    fswatch
    cmake
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
