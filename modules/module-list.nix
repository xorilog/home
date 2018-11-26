{ pkgs, lib, ... }:

{
  imports = [
    ./profiles/bash.nix
    ./profiles/containers.nix
    ./profiles/desktop.nix
    ./profiles/dev.nix
    ./profiles/dev.go.nix
    ./profiles/dev.haskell.nix
    ./profiles/dev.java.nix
    ./profiles/dev.js.nix
    ./profiles/dev.python.nix
    ./profiles/dev.rust.nix
    ./profiles/docker.nix
    ./profiles/emacs.nix
    ./profiles/fish.nix
    ./profiles/gaming.nix
    ./profiles/gcloud.nix
    ./profiles/git.nix
    ./profiles/i3.nix
    ./profiles/kubernetes.nix
    ./profiles/laptop.nix
    ./profiles/media.nix
    ./profiles/openshift.nix
    ./profiles/ssh.nix
    ./profiles/tmux.nix
    ./profiles/vscode.nix
    ./profiles/zsh.nix
    ./programs/podman.nix
    ./services/shairport-sync.nix
  ];
}
