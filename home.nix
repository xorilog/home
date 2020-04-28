# This configuration file simply determines the hostname and then import both
# the default configuration (common for all machine) and specific machine
# configuration.
let
  hostName = "${builtins.readFile ./hostname}";
in
rec {
  imports = [
    # Default profile with default configuration
    ./modules/module-list.nix
    # Machine specific configuration files
    (./machines + "/${hostName}.nix")
  ];
}
