# Libvirt virtualisation configuration (pattern vdemeester)
{ config, lib, pkgs, desktop, ... }:
{
  # Libvirt configuration
  virtualisation.libvirtd = {
    enable = true;
    # UEFI boot support
    qemu.ovmf.enable = true;
  };
  
  security.polkit.enable = true; # Required for libvirtd
  
  # Base packages
  environment.systemPackages = with pkgs; [
    qemu
    vde2
    libosinfo
  ] ++ lib.optionals (builtins.isString desktop) [
    virt-manager
  ];
  
  # Enable nested virtualisation
  boot.kernelParams = [ "kvm_intel.nested=1" ];
  environment.etc."modprobe.d/kvm.conf".text = ''
    options kvm_intel nested=1
  '';
}
