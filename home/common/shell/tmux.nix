{
  config,
  lib,
  pkgs,
  ...
}:

{
  programs.tmux =
    if pkgs.stdenv.isLinux then
      {
        enable = true;
        #sensibleOnTop = true;
        #aggressiveResize = true;
        clock24 = true;
        escapeTime = 0;
        newSession = true;
        #plugins = with pkgs.tmuxPlugins; [ prefix-highlight ];
        #secureSocket = false;
        terminal = "tmux-256color";
        #historyLimit = 30000;
        extraConfig = ''
          source-file ${config.xdg.configHome}/tmux/tmux.conf
        '';
      }
    else
      {
        enable = true;
        #sensibleOnTop = true;
        #aggressiveResize = true;
        newSession = true;
        #plugins = with pkgs.tmuxPlugins; [ prefix-highlight ];
        #secureSocket = false;
        #    terminal = "tmux-256color";
        #historyLimit = 30000;
        #    extraConfig = ''
        #      source-file ${config.xdg.configHome}/tmux/tmux.conf
        #    '';
      };
  xdg.configFile."tmux/tmux.conf".source = ./tmux/tmux.conf;
}
