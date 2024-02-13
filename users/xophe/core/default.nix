{ lib, config, pkgs, nixosConfig, ... }:

let
  inherit (lib) versionOlder;
in
{
  imports = [
    ../../modules/shells/bash.nix
    ../../modules/shells/zsh.nix
    ../../modules/tools/direnv.nix
    ../../modules/tools/fzf.nix
    ../../modules/tools/gopass.nix
    ../../modules/tools/sops.nix
    ../../modules/tools/age.nix
    ../../modules/tools/htop.nix
    ../../modules/tools/tmux.nix
    ../../modules/tools/xdg.nix
    ./git.nix
    ./gpg.nix
    ./neovim.nix
  ];

  home = {
    stateVersion = "21.03";
    packages = with pkgs; [
      google-chrome
      # Common tools
      htop
      iftop
      tmux
      jq
      wget

      # Infrastructure
      #aws-vault
      #awscli2
      # Authenticator is in version 0.4.0 and we need to use version 0.5 at least
      #aws-iam-authenticator
      kubectl
      docker-compose
      terragrunt
      # terraform_0_14 <- deprecated
      terraform
      tfswitch
      terraform-docs

      # Real editor
      vscode
      yed

      # languages
      #python3

      # Go
      #gcc
      #gopls
      #jetbrains.goland

      # Graphical
      xclip
      shutter

      # Build
      #neovim-unwrapped # uses an overlay to build from master (i want neovim 0.5.0 version)
      # GPG Yubikey etc
      yubico-piv-tool
      yubikey-personalization
      #yubioath-desktop # removed.
      yubikey-manager

      # Gnupg
      #gnupg
      #pinentry # dialog

      # System information
      inxi
    ];
  };

  # manpages are broken on 21.05 and home-manager (for some reason..)
  # (versionOlder nixosConfig.system.nixos.release "21.11");
  manual.manpages.enable = true;

  xdg.configFile."nixpkgs/config.nix".text = ''
    {
      allowUnfree = true;
      packageOverrides = pkgs: {
        nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
          inherit pkgs;
        };
      };
    }
  '';
  xdg.configFile."nr/default" = {
    text = builtins.toJSON [
      { cmd = "ncdu"; }
      { cmd = "sshfs"; }
      { cmd = "lspci"; pkg = "pciutils"; }
      { cmd = "lsusb"; pkg = "usbutils"; }
      { cmd = "9"; pkg = "plan9port"; }
      { cmd = "wakeonlan"; pkg = "python36Packages.wakeonlan"; }
    ];
    onChange = "${pkgs.my.nr}/bin/nr default";
  };



  # programs.gpg.enable = true;


  #programs.go.enable = true;
  # Always set GOROOT
  #config.environment.variables = { GOROOT = [ "${pkgs.go.out}/share/go" ]; };
}
