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
    # base
    kubectl

    # run localy
    k3s
    kube3d
    kind
    minikube

    # Operate / Dev
    kustomize
    kail
    kubectx
    kubernetes-helm
    helmfile

    # visualization
    k9s
    lens
    # our own scripts
    # knd
    # bekind
  ];
}
