{ config, lib, pkgs, ... }:

with lib;
let
  knd = pkgs.writeScriptBin "knd" ''
    #!${pkgs.stdenv.shell}
    ${pkgs.kubectl}/bin/kubectl get namespaces -o name | ${pkgs.fzf}/bin/fzf --multi | xargs kubectl delete
  '';
in
{
  home.packages = with pkgs; [
    #cri-tools
    k3s
    kail
    kubectl
    kube3d
    kustomize
    kubectx
    kind
    minikube
    # our own scripts
    # knd
    # bekind
  ];
}
