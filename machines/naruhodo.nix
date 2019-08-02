{ pkgs, ... }:

with import ../assets/machines.nix;{
  imports = [
    ./base.fedora.nix
  ];
  home.packages = with pkgs; [
    kubectx
    kustomize
    golangci-lint
    nur.repos.vdemeester.ram
    nur.repos.vdemeester.operator-sdk
  ];
  profiles.containers.kubernetes = {
    enable = true;
    containers = false;
    minikube.enable = true;
    #minikube.package = pkgs.nur.repos.vdemeester.minikube;
  };
  profiles.zsh = {
    enable = true;
  };
  profiles.ssh.machines = sshConfig;
  profiles.dev = {
    enable = true;
  };
  profiles.emacs = {
    enable = true;
    texlive = false;
    daemonService = true;
    capture = true;
  };
  home.file.".local/share/applications/redhat-vpn.desktop".source = ../assets/redhat-vpn.desktop;
  # FIXME(vdemeester) move this to the bootstrap shell
  # xdg.configFile."user-dirs.dirs".source = ../modules/profiles/assets/xorg/user-dirs.dirs;
}
