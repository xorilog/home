{
  config,
  pkgs,
  lib,
  ...
}:
{
  aliases = {
    mkdir = ''mkdir -p -v''; # options --parents --verbose Compatible Linux et macOS
    rm = ''rm -i''; # option --interactive Compatible Linux et macOS
    cp = ''cp -i''; # option --interactive Compatible Linux et macOS
    mv = ''mv -i''; # option --interactive Compatible Linux et macOS
    gcd = ''cd (git root)'';
    ls = ''eza'';
    ll = ''eza --long'';
    la = ''eza --all'';
    l = ''eza --long --all --header'';
    t = ''eza --tree --level=2'';
    wget = ''wget -c'';
    map = ''xargs -n1'';
  }
  // lib.optionalAttrs pkgs.stdenv.isLinux {
    ip = ''ip -c''; # Alias uniquement disponible sous Linux
  };

  env = ''
    export PATH=$HOME/bin:$PATH
    export LESSHISTFILE="${config.xdg.dataHome}/less_history"
    export GOPATH=${config.home.homeDirectory}
    export WEBKIT_DISABLE_COMPOSITING_MODE=1;
    export PATH=$HOME/bin:$PATH
    if [ -d $HOME/.krew/bin ]; then
      export PATH=$HOME/.krew/bin:$PATH
    fi
  '';

  historySize = 10000;
}
