{ config, lib, pkgs, ... }:
let
  iiyama_ProLite_B2712HDS = "00ffffffffffff0026cd02660101010115150103813c22782a3585a656489a24125054bfef80b300a94095008180950f714f01010101023a801871382d40582c450056502100001e000000ff0031313035313132313030323438000000fd00374c1e5111000a202020202020000000fc00504c42323731324844530a20200103020322f14f1f1413121116159005040302070601230907018301000065030c001000023a80d072382d40102c458056502100001e011d80d0721c1620102c250056502100009e011d00bc52d01e20b828554056502100001e8c0ad090204031200c405500565021000018023a801871382d40582c450056502100001e00000049";
  dell_xps_9310 = "00ffffffffffff004d10f91400000000151e0104a51d12780ede50a3544c99260f505400000001010101010101010101010101010101283c80a070b023403020360020b410000018203080a070b023403020360020b410000018000000fe0056564b3859804c513133344e31000000000002410332001200000a010a20200080";
  dell_xps_9370 = "";
  edfsf_samsung = "00ffffffffffff004c2da50c41485a5a141e01030e351e782a9ff1a555509e26105054bfef80714f81c0810081809500a9c0b3000101023a801871382d40582c4500132b2100001e000000fd00384b1e5111000a202020202020000000fc00533234453435300a2020202020000000ff0048344c4e3530313030300a202000f4";
  edfsf_samsung_office = "00ffffffffffff004c2da30c41485a5a0c1e010380351e782a9ff1a555509e26105054bfef80714f81c0810081809500a9c0b3000101023a801871382d40582c4500132b2100001e011d007251d01e206e285500132b2100001e000000fd00324b1e5111000a202020202020000000fc00533234453435300a202020202001bf020311b14690041f13120365030c001000011d00bc52d01e20b8285540132b2100001e8c0ad090204031200c405500132b210000188c0ad08a20e02d10103e9600132b21000018000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000021";
in
{
  programs.autorandr = {
    enable = true;
    hooks.postswitch."notify-i3" = "${config.xsession.windowManager.i3.package}/bin/i3-msg restart";
    hooks.postswitch."reset-background" = "systemctl --user start random-background.service";
    profiles = {
      on-the-move = {
        fingerprint = {
          eDP-1 = dell_xps_9310;
        };
        config = {
          eDP-1 = {
            enable = true;
            primary = true;
            position = "0x0";
            mode = "1920x1200";
          };
        };
      };
      office = {
        fingerprint = {
          eDP-1 = dell_xps_9310;
          DP-1 = edfsf_samsung_office;
        };
        config = {
          eDP-1 = {
            enable = true;
            position = "1920x0";
            position = "0x0";
          };
          DP-1 = {
            enable = true;
            primary = true;
            mode = "1920x1080";
            mode = "1920x1200";
          };
        };
      };
      home = {
        fingerprint = {
          eDP-1 = dell_xps_9310;
          DP-1 = iiyama_ProLite_B2712HDS;
        };
        config = {
          eDP-1 = {
            enable = true;
            position = "1920x0";
            mode = "1920x1200";
          };
          DP-1 = {
            enable = true;
            primary = true;
            mode = "1920x1080";
            position = "0x0";
          };
        };
      };
      home-3 = {
        fingerprint = {
          eDP-1 = dell_xps_9310;
          DP-1 = iiyama_ProLite_B2712HDS;
          DP-3 = edfsf_samsung;
        };
        config = {
          DP-3 = {
            enable = true;
            mode = "1920x1080";
            position = "0x0";
          };
          DP-1 = {
            enable = true;
            primary = true;
            mode = "1920x1080";
            position = "1920x0";
          };
          eDP-1 = {
            enable = true;
            position = "3840x0";
            mode = "1920x1200";
          };
        };
      };
    };
  };
}
