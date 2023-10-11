# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:
with lib;
let
  hostname = "nixophe";
  secretPath = ../../secrets/machines.nix;
  secretCondition = (builtins.pathExists secretPath);

  ip = strings.optionalString secretCondition (import secretPath).wireguard.ips."${hostname}";
  ips = lists.optionals secretCondition ([ "${ip}/24" ]);
  endpointIP = strings.optionalString secretCondition (import secretPath).wg.endpointIP;
  endpointPort = if secretCondition then (import secretPath).wg.listenPort else 0;
  # Some replace-secret-host-here stuff to do FIX ME !;
  endpointPublicKey = strings.optionalString secretCondition (import secretPath).wireguard.replace-secret-host-here.publicKey;
  persistentKeepalive = strings.optionalString secretCondition (import secretPath).wg.persistentKeepalive;
  allowedIPs = lists.optionals secretCondition ([ (import secretPath).wg.allowedIPs ]);
  wireguardDNS = strings.optionalString secretCondition (import secretPath).wg.wireguardDNS;
in
{
  imports =
    [
      # Include the results of the hardware scan.
      ../hardware/dell-xps-13-9310.nix
      (import ../../nix).home-manager
      ../modules
      (import ../../users).xophe
      (import ../../users).root
    ];

  # Add required elements to play with zfs.
  boot.supportedFilesystems = [ "zfs" ];

  # Add hostID (from: head -c4 /dev/urandom | od -A none -t x4) needed by zfs https://discourse.nixos.org/t/feedback-on-a-user-guide-i-created-on-installing-nixos-with-zfs/5986/4?u=srgom
  networking.hostId = "c8d9352c";

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Yubikey here

  # Minimal list of modules to use the EFI system partition and the YubiKey
  # Addition of uas usbcore and usb_storage tu try the latest kernel
  boot.initrd.kernelModules = [ "vfat" "nls_cp437" "nls_iso8859-1" "usbhid" "uas" "usbcore" "usb_storage" ];
  #boot.initrd.kernelModules = [ "vfat" "nls_cp437" "nls_iso8859-1" "usbhid" ];

  # Crypto setup, set modules accordingly
  boot.initrd.luks.cryptoModules = [ "aes" "xts" "sha256" "sha512" "cbc" ];

  # Enable support for the YubiKey PBA
  boot.initrd.luks.yubikeySupport = true;

  # Configuration to use your Luks device
  boot.initrd.luks.devices = {
    crypted = {
      device = "/dev/disk/by-uuid/abbdad3e-93b4-4b6e-989f-8fb8dda493b1";
      preLVM = true; # You may want to set this to false if you need to start a network service first
      yubikey = {
        slot = 2;
        gracePeriod = 30; # Time to wait for the yubikey to be inserted
        twoFactor = true; # Set to false if you did not set up a user password.
        keyLength = 64; # Set to $KEY_LENGTH/8
        saltLength = 16; # Set to $SALT_LENGTH
        storage = {
          device = "/dev/nvme0n1p1";
        };
      };
    };
  };

  # Yubikey End

  networking = {
    hostName = hostname; # Define your hostname.

    # The global useDHCP flag is deprecated, therefore explicitly set to false here.
    # Per-interface useDHCP will be mandatory in the future, so this generated config
    # replicates the default behaviour.
    useDHCP = false;

    # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
    # networking.interfaces.enp0s13f0u3u3.useDHCP = false;
    #interfaces.wlp0s20f3.useDHCP = true;

    # Configure network proxy if necessary
    # networking.proxy.default = "http://user:password@proxy:port/";
    # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  };

  services.hardware.bolt.enable = true;

  profiles = {
    desktop.i3.enable = true;
    # desktop.sway.enable = true;
    #desktop.gnome.enable = true;
    edf-sf.enable = true;
    laptop.enable = true;
    keybase.enable = true;
    home = true;
    dev.enable = true;
    yubikey = { enable = true; u2f = false; autoLock = false; };
    virtualization = { enable = true; nested = true; };
    docker.enable = true;
    tailscale.enable = true;
  };
  services.xserver.videoDrivers = [ "displaylink" "modesetting" ];
  environment.systemPackages = with pkgs; [
    virt-manager
    # force xbacklight to work
    acpilight
    docker-client
  ];

  # Temp
  # networking.firewall.trustedInterfaces = [ "wg0" ];
  services = {
    #dockerRegistry = {
    #  enable = true;
    #  listenAddress = "0.0.0.0";
    #  enableGarbageCollect = true;
    #};
    wireguard = {
      enable = false;
      ips = ips;
      endpoint = endpointIP;
      #wireguardDNS = wireguardDNS;
      endpointPort = endpointPort;
      endpointPublicKey = endpointPublicKey;
      #allowedIPs = allowedIPs;
      #persistentKeepalive = persistentKeepalive;
    };

    # gvfs to browse samba shares with GTK-Based apps like nautilus
    gvfs.enable = true;
    udev.extraRules = ''
      # Rule for screen Backlight https://gitlab.com/wavexx/acpilight
      SUBSYSTEM=="backlight", ACTION=="add", RUN+="${pkgs.coreutils}/bin/chgrp video /sys/class/backlight/%k/brightness", RUN+="${pkgs.coreutils}/bin/chmod g+w /sys/class/backlight/%k/brightness"
      # Rule for keyboard backlight
      SUBSYSTEM=="leds", ACTION=="add", KERNEL=="*::kbd_backlight", RUN+="${pkgs.coreutils}/bin/chgrp video /sys/class/leds/%k/brightness", RUN+="${pkgs.coreutils}/bin/chmod g+w /sys/class/leds/%k/brightness"
    '';
  };

  virtualisation = {
    podman.enable = true;
    containers = {
      enable = true;
      registries = {
        search = [ "docker.io" "quay.io" "docker.pkg.github.com" "ghcr.io" ];
      };
      policy = {
        default = [{ type = "insecureAcceptAnything"; }];
        transports = {
          docker-daemon = {
            "" = [{ type = "insecureAcceptAnything"; }];
          };
        };
      };
    };
  };





  # Set default EDITOR system wide
  environment.variables.EDITOR = "vim";

  # Set your time zone.
  time.timeZone = "Europe/Paris";


  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };


  nixpkgs.config = {
    allowUnfree = true;
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    enableExtraSocket = true;
    # defaultCacheTtlSsh = 7200;
    # pinEntryFlavor = "gtk2";
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
  networking.firewall.allowPing = true;
  # warning: Strict reverse path filtering breaks Tailscale exit node use and some subnet routing setups. Consider setting `networking.firewall.checkReversePath` = 'loose'
  networking.firewall.checkReversePath = "loose";
  # Samba discovery of machines and shares https://wiki.archlinux.org/index.php/Samba#.22Browsing.22_network_fails_with_.22Failed_to_retrieve_share_list_from_server.22
  networking.firewall.extraCommands = ''iptables -t raw -A OUTPUT -p udp -m udp --dport 137 -j CT --helper netbios-ns'';

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?

}

