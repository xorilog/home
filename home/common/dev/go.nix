{ config, pkgs, ... }:

{
  home.sessionVariables = {
    GOPATH = "${config.home.homeDirectory}";
  };
  home.packages = with pkgs; [
    gcc
    go_1_24
    godef
    golangci-lint
    golint
    gopkgs
    gopls
    go-outline
    go-symbols
    delve
    gotools
    gotestsum
    gofumpt
    jetbrains.goland
    jetbrains.jcef
    # misc
    protobuf
    # not really go but still
    gosmee
    # cue
  ];
}
