{
  config,
  lib,
  pkgs,
  ...
}:

{
  home.sessionVariables = {
    GOPATH = "${config.home.homeDirectory}";
  };
  home.packages = with pkgs; [
    # jetbrains.clion # C/C++ IDE from JetBrains
    jetbrains.datagrip # Database IDE from JetBrains
    # jetbrains.dataspell # Data science IDE from JetBrains
    jetbrains.goland # Go IDE from JetBrains
    jetbrains.jcef # Jetbrains' fork of JCEF (needed for ai )
    # jetbrains.idea-ultimate # Paid-for Java, Kotlin, Groovy and Scala IDE from jetbrains
    # jetbrains.phpstorm # PHP IDE from JetBrains
    # jetbrains.pycharm-professional # Paid-for Python IDE from JetBrains
    # jetbrains.rider # .NET IDE from JetBrains
    # jetbrains.ruby-mine # Ruby IDE from JetBrains
    # jetbrains.rust-rover # Rust IDE from JetBrains
    # jetbrains.webstorm # Web IDE from JetBrains
  ];
}
