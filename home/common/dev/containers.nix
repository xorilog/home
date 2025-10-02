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

    # AWS
    aws-vault
    aws-iam-authenticator
    awscli2

    pass
  ];

  programs.zsh.sessionVariables = {
    AWS_VAULT_BACKEND = "pass";
    AWS_VAULT_PASS_PREFIX = "vault";
    AWS_VAULT_PASS_PASSWORD_STORE_DIR = ''''${HOME}/sync/password-store'';
  };
}
