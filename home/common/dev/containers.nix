{ pkgs, ... }:

{
  home.packages = with pkgs; [
    skopeo
    oras
    dive

    #cri-tools
    # base
    kubectl

    # run localy
    ko
    #k3s
    kube3d
    krew
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
    # lens not using ...
    # our own scripts
    # knd
    # bekind
    stern
  ];
}
