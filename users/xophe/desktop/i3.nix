{ config, nixosConfig, lib, pkgs, ... }:

with lib;
let
  # FIXME(change this at some point)
  powermenu = pkgs.writeScript "powermenu.sh" ''
    #!${pkgs.stdenv.shell}
    MENU="$(${pkgs.rofi}/bin/rofi -sep "|" -dmenu -i -p 'System' -location 3 -xoffset -10 -yoffset 32 -width 20 -hide-scrollbar -line-padding 4 -padding 20 -lines 5 <<< "Suspend|Hibernate|Reboot|Shutdown")"
    case "$MENU" in
      *Suspend) systemctl suspend;;
      *Hibernate) systemctl hibernate;;
      *Reboot) systemctl reboot ;;
      *Shutdown) systemctl -i poweroff
    esac
  '';
  # lockCommand = "${pkgs.i3lock-color}/bin/i3lock-color -c 666666";
  lockCommand = "${pkgs.betterlockscreen}/bin/betterlockscreen -l dim";
in
{
  imports = [
    ./alacritty.nix
    ./autorandr.nix
    ./dconf.nix
    ./xsession.nix
  ];
  home.sessionVariables = { WEBKIT_DISABLE_COMPOSITING_MODE = 1; };
  home.packages = with pkgs; [
    gThumb
    alacritty
    arandr
    # TODO switch to betterlockscreen
    betterlockscreen
    i3lock-color
    libnotify
    maim
    slop
    # Gnome3 relica
    gnome3.dconf-editor
    gnome3.pomodoro
    # FIXME move this elsewhere
    pop-gtk-theme
    pop-icon-theme
    pinentry-gnome
    # tilix

    gnome3.nautilus
    aspell
    aspellDicts.en
    aspellDicts.fr
    hunspell
    hunspellDicts.en_US-large
    hunspellDicts.en_GB-ize
    hunspellDicts.fr-any
    wmctrl
    xclip
    xdg-user-dirs
    xdg_utils
    xsel
  ];
  xdg.configFile."rofi/slate.rasi".text = ''
    * {
      background-color: #282C33;
      border-color: #2e343f;
      text-color: #8ca0aa;
      spacing: 0;
      width: 512px;
    }

    inputbar {
      border: 0 0 1px 0;
      children: [prompt,entry];
    }

    prompt {
      padding: 16px;
      border: 0 1px 0 0;
    }

    textbox {
      background-color: #2e343f;
      border: 0 0 1px 0;
      border-color: #282C33;
      padding: 8px 16px;
    }

    entry {
      padding: 16px;
    }

    listview {
      cycle: false;
      margin: 0 0 -1px 0;
      scrollbar: false;
    }

    element {
      border: 0 0 1px 0;
      padding: 16px;
    }

    element selected {
      background-color: #2e343f;
    }
  '';
  programs.rofi = {
    enable = true;
    package = pkgs.rofi.override { plugins = [ pkgs.rofi-emoji pkgs.rofi-menugen pkgs.rofi-mpd ]; };
    font = "Ubuntu Mono 14";
    terminal = "${pkgs.alacritty}/bin/alacritty";
    theme = "slate";
  };
  services = {
    blueman-applet.enable = true;
    pasystray.enable = true;
    dunst = {
      enable = true;
      settings = {
        global = {
          geometry = "500x5-10+10";
          follow = "keyboard";
          frame_color = "#cccccc";
          font = "Ubuntu Mono 11";
          indicate_hidden = "yes";
          separator_height = 1;
          padding = 8;
          horizontal_padding = 8;
          frame_width = 2;
          sort = "yes";
          markup = "full";
          format = "<b>%s</b>\n%b";
          ignore_newline = "no";
          stack_duplicates = true;
          show_indicators = "yes";
          history_length = 40;
        };
        shortcuts = {
          close = "ctrl+space";
          close_all = "ctrl+shift+space";
          history = "ctrl+percent";
          context = "ctrl+shift+period";
        };
        urgency_low = {
          background = "#000000";
          foreground = "#ffffff";
          timeout = 4;
        };
        urgency_normal = {
          background = "#000000";
          foreground = "#ffffff";
          timeout = 6;
        };
        urgency_critical = {
          background = "#000000";
          foreground = "#cf6a4c";
          timeout = 0;
        };
      };
    };
    udiskie.enable = true;
    network-manager-applet.enable = true;
    screen-locker = {
      enable = true;
      lockCmd = lockCommand;
      inactiveInterval = 60;
      # xautolockExtraOptions = [
      #   "Xautolock.killer: systemctl suspend"
      # ];
    };
    random-background = {
      enable = true;
      imageDirectory = "${config.home.homeDirectory}/desktop/pictures/walls";
      interval = "5h";
    };
  };
  xsession.windowManager.i3 = {
    package = pkgs.i3-gaps;
    enable = true;
    config = {
      fonts = [ "Ubuntu Mono 10" ];
      focus = {
        followMouse = true;
      };
      window = {
        titlebar = false;
        border = 1;
        hideEdgeBorders = "both";
      };
      keybindings = {
        "Mod4+Return" = "exec alacritty";
      };
      gaps = {
        inner = 0;
        outer = 0;
      };
      keycodebindings = {
        "Mod4+Shift+24" = "kill"; #Mod4+Shift+q
        "Mod4+33" = "exec \"rofi -show drun -modi 'drun,run,window,ssh' -kb-row-select 'Tab' -kb-row-tab '' -location 2 -hide-scrollbar -separator-style solid -font 'Ubuntu Mono 14'"; #Mod+p
        "Mod4+Shift+33" = "exec \"rofi -show combi -modi 'drun,run,window,ssh,combi' -kb-row-select 'Tab' -kb-row-tab '' -location 2 -hide-scrollbar -separator-style solid -font 'Ubuntu Mono 14'"; #Mod+P
        "Mod4+Control+33" = "exec \"rofi -show emoji -modi emoji -location 2 -hide-scrollbar -separator-style solid -font 'Ubuntu Mono 14'|pbcopy"; #Mod+Control+P
        # "Mod4+space" = "";
        # focus window
        "Mod4+44" = "focus left";   #Mod4+j
        "Mod4+45" = "focus down";   #Mod4+k
        "Mod4+46" = "focus up";     #Mod4+l
        "Mod4+47" = "focus right";  #Mod4+;
        "Mod4+38" = "focus parent"; #Mod4+a
        # move focused window
        "Mod4+Shift+44" = "move left";  #Mod4+Shift+j
        "Mod4+Shift+45" = "move down";  #Mod4+Shift+k
        "Mod4+Shift+46" = "move up";    #Mod4+Shift+l
        "Mod4+Shift+47" = "move right"; #Mod4+Shift+;
        # resize
        "Mod4+Control+44" = "resize shrink width 5px or 5ppt";  #Mod4+Control+j
        "Mod4+Control+45" = "resize grow width 5px or 5ppt";    #Mod4+Control+k
        "Mod4+Control+46" = "resize shrink height 5px or 5ppt"; #Mod4+Control+l
        "Mod4+Control+47" = "resize grow height 5px or 5ppt";   #Mod4+Control+;
        # gaps
        "Mod4+Mod1+44" = "gaps inner current plus 5";   #Mod4+Alt+j
        "Mod4+Mod1+45" = "gaps inner current minus 5";  #Mod4+Alt+k
        "Mod4+Mod1+46" = "gaps outer current plus 5";   #Mod4+Alt+l
        "Mod4+Mod1+47" = "gaps outer current minus 5";  #Mod4+Alt+;
        # Fullscreen
        "Mod4+41" = "fullscreen toggle"; #Mod4+f
        # Change container layout
        "Mod4+39" = "layout stacking";     #Mod4+s
        "Mod4+25" = "layout tabbed";       #Mod4+w
        "Mod4+26" = "layout toggle split"; #Mod4+e
        # Manage floating
        "Mod4+Shift+61" = "floating toggle";  #Mod4+Shift+/
        "Mod4+61" = "focus mode_toggle";      #Mod4+/
        # manage workspace
        "Mod4+113" = "workspace prev_on_output"; #Mod4+left
        "Mod4+112" = "workspace prev_on_output"; #Mod4+Prior (Page Up)
        "Mod4+114" = "workspace next_on_output"; #Mod4+right
        "Mod4+117" = "workspace next_on_output"; #Mod4+Next (Page Down)
        # manage output
        "Mod4+Shift+113" = "focus output left";  #Mod4+Shift+left
        "Mod4+Shift+116" = "focus output down";  #Mod4+Shift+Down
        "Mod4+Shift+111" = "focus output up";    #Mod4+Shift+Up
        "Mod4+Shift+114" = "focus output right"; #Mod4+Shift+Right
        # Custom keybinding
        "Mod4+Shift+32" = "exec ${lockCommand}"; #Mod4+Shift+o
        # "Mod4+Shift+39" = "exec ~/.screenlayout/home-work.sh && systemctl --user start random-background.service";
        # "Mod4+24" = "border toggle"; #Mod4+q commented xophe (cannot do bindsym and bindcode on same keys)#
        # TODO transform this into mode with multiple "capture" target
        # "Mod4+32" = "exec capture"; #Mod+o  commented xophe (cannot do bindsym and bindcode on same keys)#
      };
      modes = { };
      bars = [
        {
          mode = "hide";
          position = "bottom";
          trayOutput = "primary";
          statusCommand = "${pkgs.i3status}/bin/i3status";
          fonts = [ "Fira Code 12" ];
        }
      ];
    };
    extraConfig = ''
      set $mod Mod4

      # Use Mouse+$mod to drag floating windows to their wanted position
      floating_modifier $mod

      set $WS0 0
      set $WS1 1
      set $WS2 2
      set $WS3 3
      set $WS4 4
      set $WS5 5
      set $WS6 6
      set $WS7 7
      set $WS8 8
      set $WS9 9

      # switch to workspace
      bindcode $mod+10 workspace $WS1
      bindcode $mod+11 workspace $WS2
      bindcode $mod+12 workspace $WS3
      bindcode $mod+13 workspace $WS4
      bindcode $mod+14 workspace $WS5
      bindcode $mod+15 workspace $WS6
      bindcode $mod+16 workspace $WS7
      bindcode $mod+17 workspace $WS8
      bindcode $mod+18 workspace $WS9
      bindcode $mod+19 workspace $WS0

      # move focused container to workspace
      bindcode $mod+Shift+10 move container to workspace $WS1
      bindcode $mod+Shift+11 move container to workspace $WS2
      bindcode $mod+Shift+12 move container to workspace $WS3
      bindcode $mod+Shift+13 move container to workspace $WS4
      bindcode $mod+Shift+14 move container to workspace $WS5
      bindcode $mod+Shift+15 move container to workspace $WS6
      bindcode $mod+Shift+16 move container to workspace $WS7
      bindcode $mod+Shift+17 move container to workspace $WS8
      bindcode $mod+Shift+18 move container to workspace $WS9
      bindcode $mod+Shift+19 move container to workspace $WS0

      #assign [class="Firefox" window_role="browser"] → $WS1
      #assign [class="Google-chrome" window_role="browser"] → $WS1

      for_window [title="capture"] floating enable;

      bindsym XF86MonBrightnessUp exec "xbacklight -inc 10"
      bindsym XF86MonBrightnessDown exec "xbacklight -dec 10"
      bindsym shift+XF86MonBrightnessUp exec "xbacklight -inc 1"
      bindsym shift+XF86MonBrightnessDown exec "xbacklight -dec 1"
      bindsym XF86AudioLowerVolume exec "pactl set-sink-mute @DEFAULT_SINK@ false ; pactl set-sink-volume @DEFAULT_SINK@ -5%"
      bindsym XF86AudioRaiseVolume exec "pactl set-sink-mute @DEFAULT_SINK@ false ; pactl set-sink-volume @DEFAULT_SINK@ +5%"
      bindsym XF86AudioMute exec "pactl set-sink-mute @DEFAULT_SINK@ toggle"
      bindsym XF86AudioMicMute exec "pactl set-source-mute @DEFAULT_SOURCE@ toggle"
      bindsym XF86AudioPlay exec "playerctl play-pause"
      bindsym XF86AudioNext exec "playerctl next"
      bindsym XF86AudioPrev exec "playerctl previous"

      # reload the configuration file
      bindsym $mod+Shift+x reload
      # restart i3 inplace (preserves your layout/session, can be used to upgrade i3)
      # bindsym $mod+Shift+o restart ## xophe (cannot do bindsym and bindcode on same keys)
      # exit i3 (logs you out of your X session)
      # xophe (cannot do bindsym and bindcode on same keys): rofi also using -> $mod+Shift+p
      #bindsym $mod+Shift+p exec "i3-nagbar -t warning -m 'You pressed the exit shortcut. Do you really want to exit i3?' -b 'Yes, exit i3' 'i3-msg exit'"
      # powermenu
      bindsym $mod+F12 exec ${powermenu}
      bindsym $mod+F10 exec ${pkgs.my.scripts}/bin/shot %d
      bindsym $mod+Shift+F10 exec ${pkgs.my.scripts}/bin/shotf %d

      # screen management
      bindsym $mod+F11 exec "autorandr -c"
      bindsym $mod+Shift+F11 exec "arandr"

      # move workspace to output
      set $workspace_move Move workspace to output : [l]eft [r]ight [d]own [u]p

      mode "$workspace_move" {
      bindsym left move workspace to output left
        bindsym l move workspace to output left

      bindsym right move workspace to output right
        bindsym r move workspace to output right

      bindsym down move workspace to output down
        bindsym d move workspace to output down

      bindsym up move workspace to output up
        bindsym u move workspace to output up

      bindsym Escape mode "default"
      bindsym Return mode "default"
        }

        bindsym $mod+m mode "$workspace_move"

      # resize window (you can also use the mouse for that)
      mode "resize" {
        # These bindings trigger as soon as you enter the resize mode

      # Pressing left will shrink the window’s width.
      # Pressing right will grow the window’s width.
      # Pressing up will shrink the window’s height.
      # Pressing down will grow the window’s height.
      bindsym t resize shrink width 10 px or 10 ppt
      bindsym s resize grow height 10 px or 10 ppt
      bindsym r resize shrink height 10 px or 10 ppt
      bindsym n resize grow width 10 px or 10 ppt

      # same bindings, but for the arrow keys
      bindsym Left resize shrink width 10 px or 10 ppt
      bindsym Down resize grow height 10 px or 10 ppt
      bindsym Up resize shrink height 10 px or 10 ppt
      bindsym Right resize grow width 10 px or 10 ppt

      # back to normal: Enter or Escape
      bindsym Return mode "default"
      bindsym Escape mode "default"
        }

      bindsym $mod+o mode "resize"
      ## quick terminal (tmux)
      exec --no-startup-id alacritty --title metask --class metask --command tmux
      for_window [instance="metask"] floating enable;
      for_window [instance="metask"] move scratchpad; [instance="metask"] scratchpad show; move position center; move scratchpad
      bindcode $mod+49 [instance="metask"] scratchpad show

      ### pomodoro
      ## bepo s = 45
      ## bepo p = 26
      #set $pomodoro "pomodoro: [s]tart s[t]op [p]ause-resume"
      #mode $pomodoro {
      #  bindcode 45 exec "${pkgs.gnome3.pomodoro}/bin/gnome-pomodoro --no-default-window --start"; mode "default"
      #  bindcode 44 exec "${pkgs.gnome3.pomodoro}/bin/gnome-pomodoro --no-default-window --stop"; mode "default"
      #  bindcode 26 exec "${pkgs.gnome3.pomodoro}/bin/gnome-pomodoro --no-default-window --pause-resume"; mode "default"
      #  bindsym Return mode "default"
      #  bindsym Escape mode "default"
      #}
      #bindcode $mod+43 mode $pomodoro

      ## scratchpad
      set $scratchpad "scratchpad: [$]terminal [p]avucontrol"
      mode $scratchpad {
           bindcode 49 [instance="metask"] scratchpad show; mode "default"
           bindcode 33 [class="(?i)pavucontrol"] scratchpad show; mode "default"
           bindsym Return mode "default"
           bindsym Escape mode "default"
      }
      # bindcode $mod+49 mode $scratchpad
      # System menu
      set $sysmenu "system:  [s]uspend [l]ock [r]estart [b]lank-screen [p]oweroff reload-[c]onf e[x]it"
      bindsym $mod+q mode $sysmenu
      mode $sysmenu {
          # restart i3 inplace (preserves your layout/session)
          bindsym s exec ~/.i3/status_scripts/ambisleep; mode "default"
          bindsym l exec i3lock -c 5a5376; mode "default"
          bindsym r restart
          bindsym b exec "xset dpms force off"; mode "default"
          bindsym p exec systemctl shutdown
          bindsym c reload; mode "default"
          bindsym x exit
          bindsym Return mode "default"
          bindsym Escape mode "default"
          bindsym $mod+q mode "default"
      }
    '';
  };
  # FIXME switch to polybar ?
  xdg.configFile."i3status/config".text = ''
    # i3status configuration file.
    # see "man i3status" for documentation.

    # It is important that this file is edited as UTF-8.
    # The following line should contain a sharp s:
    # ß
    # If the above line is not correctly displayed, fix your editor first!

    general {
      colors = true
      interval = 2
    }

    order += "ipv6"
    order += "wireless _first_"
    order += "ethernet _first_"
    order += "path_exists 🔑"
    order += "battery 0"
    order += "load"
    order += "tztime local"

    battery 0 {
      format = "%status %percentage %remaining"
      format_down = "No battery"
      status_chr = "⚇"
      status_bat = "⚡"
      status_full = "☻"
      status_unk = "?"
      path = "/sys/class/power_supply/BAT%d/uevent"
      low_threshold = 10
    }

    run_watch 🐳 {
      pidfile = "/run/docker.pid"
    }

    path_exists 🔑 {
      # check for tun0 config (classic openvpn)
      path = "/proc/sys/net/ipv4/conf/tun0"
    }

    tztime local {
      format = "%Y-%m-%d %H:%M:%S"
    }

    load {
      format = "%1min"
    }

    cpu_temperature 0 {
      format = "T: %degrees °C"
      path = "/sys/class/hwmon/hwmon0/temp1_input"
    }

    disk "/" {
      format = "%avail"
    }

    wireless _first_ {
        format_up = "W: (%quality at %essid, %bitrate) %ip"
        format_down = "W: down"
    }

    ethernet _first_ {
        format_up = "E: %ip (%speed)"
        format_down = "E: down"
    }

    memory {
        format = "%used"
        threshold_degraded = "10%"
        format_degraded = "MEMORY: %free"
    }
  '';
}
