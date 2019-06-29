{ pkgs, ... }:

{
  imports = [
    ./base.fedora.nix
  ];
  home.packages = with pkgs; [
    kubectx
    kustomize
  ];
  profiles.containers.kubernetes = {
    enable = true;
    containers = false;
  };
  profiles.zsh = {
    enable = true;
  };
  profiles.dev = {
    enable = true;
  };
  profiles.emacs = {
    enable = true;
    texlive = false;
    daemonService = true;
  };
  # FIXME(vdemeester) move this to the bootstrap shell
  # xdg.configFile."user-dirs.dirs".source = ../modules/profiles/assets/xorg/user-dirs.dirs;
}
