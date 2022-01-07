{ sources ? import ../.
, pkgs ? sources.pkgs { }
}:
rec {
  # pre nur-packages import
  scripts = pkgs.callPackage ./my/scripts { };
  vrsync = pkgs.callPackage ./my/vrsync { };
  vde-thinkpad = pkgs.callPackage ./my/vde-thinkpad { };
  bekind = pkgs.callPackage ../../tools/bekind { };

  # Mine
  ape = pkgs.callPackage ./ape { };
  fhs-std = pkgs.callPackage ./fhs/std.nix { };
  nr = pkgs.callPackage ./nr { };
  ram = pkgs.callPackage ./ram { };
  #sec = pkgs.callPackage ./sec { };
  systemd-email = pkgs.callPackage ./systemd-email { };
  yak = pkgs.callPackage ./yak { };

  # Maybe upstream
  athens = pkgs.callPackage ./athens { };
  envbox = pkgs.callPackage ./envbox { };
  esc = pkgs.callPackage ./esc { };
  #gogo-protobuf = pkgs.callPackage ./gogo-protobuf {};
  gorun = pkgs.callPackage ./gorun { };
  govanityurl = pkgs.callPackage ./govanityurl { };
  ko = pkgs.callPackage ./ko { };
  kss = pkgs.callPackage ./kss { };
  batzconverter = pkgs.callPackage ./batzconverter { };
  #kubernix = pkgs.callPackage ./kubernix { };
  krew = pkgs.callPackage ./krew { };
  prm = pkgs.callPackage ./prm { };
  #protobuild = pkgs.callPackage ./protobuild { };
  rmapi = pkgs.callPackage ./rmapi { };
  toolbox = pkgs.callPackage ./toolbox { };
  yaspell = pkgs.callPackage ./yaspell { };

  # Operator SDK
  inherit (pkgs.callPackage ./operator-sdk { })
    operator-sdk_1
    operator-sdk_1_15
    operator-sdk_1_14
    operator-sdk_1_13
    operator-sdk_0_18
    operator-sdk_0_19
    ;
  operator-sdk = operator-sdk_0_19;

  manifest-tool = pkgs.callPackage ./manifest-tool { };

  # Upstream
  buildkit = pkgs.callPackage ./buildkit { };
  buildx = pkgs.callPackage ./buildx { };
  inherit (pkgs.callPackage ./containerd { })
    containerd_1_2
    containerd_1_3
    containerd_1_4
    ;
  containerd = containerd_1_3;

  # If not useful go remove nix/packages/gnome/extensions/<extension name here>
  # gnome-shell-extension-shell = pkgs.callPackage ./gnome/extensions/shell { };
  # gnome-bluetooth-quick-connect = pkgs.callPackage ./gnome/extensions/bluetooth-quick-connect { };
  # hidetopbar = pkgs.callPackage ./gnome/extensions/hide-top-bar { };
  # noannoyance = pkgs.callPackage ./gnome/extensions/noannoyance { };
  # nightthemeswitcher = pkgs.callPackage ./gnome/extensions/nightthemeswitcher { };
  adi1090x-plymouth = pkgs.callPackage ./adi1090x-plymouth { };
}
