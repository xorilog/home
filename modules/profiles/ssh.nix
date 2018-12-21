{ config, lib, ... }:

with lib;
let
  cfg = config.profiles.ssh;
in
{
  options = {
    profiles.ssh = {
      enable = mkOption {
        default = true;
        description = "Enable ssh profile and configuration";
        type = types.bool;
      };
    };
  };
  config = mkIf cfg.enable {
    home.file.".ssh/sockets/.placeholder".text = '''';
    programs.ssh = {
      enable = true;

      serverAliveInterval = 60;
      hashKnownHosts = true;
      userKnownHostsFile = "~/.config/ssh/known_hosts";
      controlPath = "~/.ssh/sockets/%u-%l-%r@%h:%p";
    
      matchBlocks = {
        "github.com" = {
          hostname = "github.com";
          user = "git";
          extraOptions = {
            controlMaster = "auto";
            controlPersist = "360";
          };
        };
        "gitlab.com" = {
          hostname = "gitlab.com";
          user = "git";
          extraOptions = {
            controlMaster = "auto";
            controlPersist = "360";
          };
        };
        "*.local" = {
          extraOptions = {
            controlMaster = "auto";
            controlPersist = "360";
          };
        };
      };
    };
  };
}
