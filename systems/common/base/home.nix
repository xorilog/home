# Home network configuration (pattern vdemeester)
{ config, lib, pkgs, ... }:
{
  # NFS kernel parameters
  boot.kernelParams = [ "nfs.nfs4_disable_idmapping=0" "nfsd.nfs4_disable_idmapping=0" ];
  
  # Home network settings
  networking.domain = "home";
  
  # Timezone
  time.timeZone = "Europe/Paris";
}
