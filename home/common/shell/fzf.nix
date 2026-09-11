{
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultOptions = [ "--bind=ctrl-j:accept" ];
    # Atuin is sourced after fzf and already owned Ctrl-R; this just makes that
    # explicit instead of relying on ordering (and silences HM's warning).
    # To give Ctrl-R back to fzf: drop these two lines and instead add
    #   flags = [ "--disable-ctrl-r" ];
    # to programs.atuin in ./atuin.nix.
    historyWidget.command = "";
  };
}
