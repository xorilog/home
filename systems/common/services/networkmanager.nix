{
  config,
  lib,
  pkgs,
  ...
}:
{
  networking = {
    networkmanager = {
      enable = true;
      # TODO: Xophe let's check without this parameter for now and maybe change later.
      # I guess it will set the wifi interface name to iwd.
      #wifi = {
      #  backend = "iwd";
      #};
      unmanaged = [
        "interface-name:br-*"
        "interface-name:ve-*" # FIXME are those docker's or libvirt's
        "interface-name:veth-*" # FIXME are those docker's or libvirt's
      ]
      # Do not manage wireguard
      ++ lib.optionals config.networking.wireguard.enable [ "interface-name:wg0" ]
      # Do not manage docker interfaces
      ++ lib.optionals config.virtualisation.docker.enable [ "interface-name:docker0" ]
      # Do not manager libvirt interfaces
      ++ lib.optionals config.virtualisation.libvirtd.enable [ "interface-name:virbr*" ];
      plugins = with pkgs; [ networkmanager-openvpn ];
    };
  };

  # Workaround https://github.com/NixOS/nixpkgs/issues/180175
  systemd.services.NetworkManager-wait-online.enable = false;
}
