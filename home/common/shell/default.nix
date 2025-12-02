{
  lib,
  config,
  pkgs,
  nixosConfig,
  ...
}:
{
  imports = [
    # Modules shells
    ./bash.nix
    ./zsh.nix
    ./xdg.nix
    ./git.nix
    ./gpg.nix
    ./neovim.nix

    # Shell tools (migrated from tools/)
    ./direnv.nix
    ./fzf.nix
    ./gopass.nix
    ./htop.nix
    ./tmux.nix
    ./atuin.nix
  ];

  programs = {
    broot = {
      enable = true;
      enableZshIntegration = true;
    };
    eza.enable = true;
    fd.enable = true;
    git.enable = true;
    jq.enable = true;
  };

  home = {
    packages =
      with pkgs;
      [
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
        terragrunt
        # terraform_0_14 <- deprecated
        terraform
        tfswitch
        # TODO: https://github.com/NixOS/nixpkgs/blob/97e5d399726f2ab2d501d6c4b4cf808134e6cadc/pkgs/by-name/te/terraform-docs/package.nix#L4
        # Wait for upstream fix.
        # terraform-docs

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

        # Build
        #neovim-unwrapped # uses an overlay to build from master (i want neovim 0.5.0 version)
        # Gnupg
        #gnupg
        #pinentry # dialog

        # System information
      ]
      ++ lib.optionals pkgs.stdenv.isLinux [
        google-chrome # Sur Mac, s'installe autrement
        xclip
        shutter
        inxi
      ]
      ++ lib.optionals pkgs.stdenv.isDarwin [
        # Rien de spécifique pour l'instant
      ];
  };

  manual.manpages.enable = true;
}
