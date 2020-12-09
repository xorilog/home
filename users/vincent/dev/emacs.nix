# Note: this file is autogenerated from an org-mode file.
{ config, lib, pkgs, ... }:

with lib;
let
  capture = pkgs.writeScriptBin "capture" ''
    #!${pkgs.stdenv.shell}
    emacsclient -n -F '((name . "capture") (width . 150) (height . 90))' -e '(org-capture)'
  '';
  e = pkgs.writeScriptBin "e" ''
    #!${pkgs.stdenv.shell}
    emacs --dump-file=~/.config/emacs/emacs.pdmp $@
  '';
  et = pkgs.writeScriptBin "et" ''
    #!${pkgs.stdenv.shell}
    emacsclient --tty $@
  '';
  ec = pkgs.writeScriptBin "ec" ''
    #!${pkgs.stdenv.shell}
    emacsclient --create-frame $@
  '';
  myExtraPackages = epkgs: with epkgs; [
    ace-window
    aggressive-indent
    async
    avy
    bbdb
    beginend
    bongo
    color-identifiers-mode
    company
    company-emoji
    company-go
    dash
    delight
    diredfl
    dired-collapse
    dired-narrow
    dired-rsync
    dired-subtree
    dockerfile-mode
    dumb-jump
    easy-kill
    edit-indirect
    envrc
    esh-autosuggest
    eshell-prompt-extras
    esup
    expand-region
    flimenu
    # replace with flymake
    flycheck
    flycheck-golangci-lint
    forge
    git-annex
    git-commit
    gitattributes-mode
    gitconfig-mode
    github-review
    gitignore-mode
    go-mode
    gotest
    goto-last-change
    hardhat
    helpful
    highlight
    highlight-indentation
    hl-todo
    htmlize
    ibuffer-vc
    icomplete-vertical
    json-mode
    magit
    magit-annex
    magit-popup
    markdown-mode
    minions
    modus-operandi-theme
    moody
    multi-vterm
    mwim
    nix-buffer
    nix-mode
    nixpkgs-fmt
    no-littering
    ob-async
    ob-go
    ob-http
    orderless
    org-capture-pop-frame
    org-journal
    org-plus-contrib
    org-ql
    org-super-agenda
    org-tree-slide
    org-web-tools
    orgit
    ox-pandoc
    pandoc-mode
    pdf-tools
    pkgs.bookmark-plus
    pkgs.dired-plus
    projectile
    python-mode
    rainbow-delimiters
    rainbow-mode
    rg
    ripgrep
    scratch
    shr-tag-pre-highlight
    smartparens
    symbol-overlay
    trashed
    try
    undo-tree
    use-package
    visual-fill-column
    visual-regexp
    vterm
    web-mode
    wgrep
    #whole-line-or-region
    with-editor
    xterm-color
    yaml-mode
    zoom-window
  ];
in
{
  home.file.".local/share/applications/org-protocol.desktop".source = ./emacs/org-protocol.desktop;
  home.file.".local/share/applications/capture.desktop".source = ./emacs/capture.desktop;
  home.packages = with pkgs; [
    ditaa
    graphviz
    pandoc
    sqlite
    zip
    # See if I can hide this under an option
    capture
    e
    ec
    et
  ];
  programs.emacs = {
    enable = true;
    package = (pkgs.emacs.override { withGTK3 = true; withGTK2 = false; withX = true; withXwidgets = true; });
    extraPackages = myExtraPackages;
  };
  services.emacs = {
    enable = true;
    client.enable = true;
    socketActivation.enable = true;
  };
  home.sessionVariables = {
    EDITOR = "emacs";
    ALTERNATE_EDITOR = "emacs -nw";
  };
}
