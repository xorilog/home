# Common configuration for any desktop (not that laptop are a superset of desktop)

{ configs, pkgs, ...}:

{
	imports = [
		./printing.nix
		./scanning.nix
		./avahi.nix
		./syncthing.nix
	];

	boot.loader.efi.canTouchEfiVariables = true;
	boot.tmpOnTmpfs = true;

	nixpkgs.config = {
		packageOverrides = self: with self; let
			fetchNixPkgs = { rev, sha256, owner, repo }:
				fetchFromGitHub {
					inherit sha256 rev owner repo;
				};
			unstablePkgs = import (fetchNixPkgs {
				owner = "NixOS";
				repo = "nixpkgs-channels";
				rev = "9c048f4fb66adc33c6b379f2edefcb615fd53de6";
				sha256 = "18xbnfzj753bphzmgp74rn9is4n5ir4mvb4gp9lgpqrbfyy5dl2j";
			}) {};
			sbrPkgs = import (fetchNixPkgs {
				owner = "vdemeester";
				repo = "sbrpkgs";
				rev = "df281994c5e438c25af6c054ebfbd19333f3e132";
				sha256 = "0636k102vw1pmbcch75xvhjlkfk9553bcf6rba5i69m7b5bdsfd0";
			}) {};
		in {
			inherit (unstablePkgs) keybase mpv emacs ledger-cli youtube-dl i3lock-color pipenv syncthing;
			inherit (sbrPkgs) ape tuck clasp;
		};
	};
	environment.systemPackages = with pkgs; [
		dmenu2
		rofi
		dunst
		emacs
		firefox
		gnome3.defaultIconTheme
		gnome3.gnome_themes_standard
		i3status
		i3lock-color
		rofi
		rofi-pass
		pass
		libnotify
		pythonPackages.udiskie
		scrot
		termite
		xdg-user-dirs
		xdg_utils
		xlibs.xmodmap
		xorg.xbacklight
		xorg.xdpyinfo
		xorg.xhost
		xorg.xinit
		xss-lock
		xorg.xmessage
		ape
		tuck
		clasp
		keybase
		mpv
		ledger
		unzip
		peco
		networkmanagerapplet
    gnupg
    pinentry
	];
	hardware.opengl.extraPackages = [ pkgs.vaapiIntel ];
	networking.networkmanager.enable = true;
	services = {
		xserver = {
			enable = true;
			enableTCP = false;
			libinput.enable = true;
			synaptics.enable = false;
			layout = "fr(bepo),fr";
			xkbVariant = "oss";
			xkbOptions = "grp:menu_toggle,grp_led:caps,compose:caps";
			inputClassSections = [
					''
Identifier      "TypeMatrix"
MatchIsKeyboard "on"
MatchVendor     "TypeMatrix.com"
MatchProduct    "USB Keyboard"
Driver          "evdev"
Option          "XbkModel"      "tm2030USB"
Option          "XkbLayout"     "fr"
Option          "XkbVariant"    "bepo"
					''
					''
Identifier      "ErgoDox"
MatchIsKeyboard "on"
#MatchVendor     "ErgoDox_EZ"
#MatchProduct    "ErgoDox_EZ"
MatchUSBID      "feed:1307"
Driver          "evdev"
Option          "XkbLayout"     "fr"
Option          "XkbVariant"    "bepo"
					''
#					''
#Identifier "evdev touchpad off"
#MatchIsTouchpad "on"
#MatchDevicePath "/dev/input/event*"
#Driver "evdev"
#Option "Ignore" "true"
#					''
			];
			windowManager = {
				i3 = {
					enable = true;
				};
				default = "i3";
			};
			displayManager = {
				slim = {
					enable = true;
					# Probably put this into users instead ?
					defaultUser = "vincent";
				};
				sessionCommands = ''
${pkgs.networkmanagerapplet}/bin/nm-applet &
${pkgs.xlibs.xmodmap}/bin/xmodmap ~/.Xmodmap &
${pkgs.pythonPackages.udiskie}/bin/udiskie -a -t -n -F &
${pkgs.xss-lock}/bin/xss-lock --ignore-sleep i3lock-color -- --clock -i $HOME/.background-lock --tiling &
				'';
			};
		};
		# unclutter.enable = true;
		#redshift = {
		#	enable = true;
		#	brightness.day = "0.95";
		#	brightness.night = "0.7";
		#	latitude = "48.3";
		#	longitude = "7.5";
		#};
	};
	fonts = {
		enableFontDir = true;
		enableGhostscriptFonts = true;
		fonts = with pkgs; [		
			corefonts
			inconsolata
			dejavu_fonts
			ubuntu_font_family
			unifont
			emojione
			symbola
			fira
			fira-code
			fira-mono
			font-droid
			hasklig
		];
	};

	# Polkit.
	security.polkit.extraConfig = ''
	polkit.addRule(function(action, subject) {
		if ((action.id == "org.freedesktop.udisks2.filesystem-mount-system" ||
		action.id == "org.freedesktop.udisks2.encrypted-unlock-system"
		) &&
		subject.local && subject.active && subject.isInGroup("users")) {
			return polkit.Result.YES;
		}
		var YES = polkit.Result.YES;
		var permission = {
			// required for udisks1:
			"org.freedesktop.udisks.filesystem-mount": YES,
			"org.freedesktop.udisks.luks-unlock": YES,
			"org.freedesktop.udisks.drive-eject": YES,
			"org.freedesktop.udisks.drive-detach": YES,
			// required for udisks2:
			"org.freedesktop.udisks2.filesystem-mount": YES,
			"org.freedesktop.udisks2.encrypted-unlock": YES,
			"org.freedesktop.udisks2.eject-media": YES,
			"org.freedesktop.udisks2.power-off-drive": YES,
			// required for udisks2 if using udiskie from another seat (e.g. systemd):
			"org.freedesktop.udisks2.filesystem-mount-other-seat": YES,
			"org.freedesktop.udisks2.filesystem-unmount-others": YES,
			"org.freedesktop.udisks2.encrypted-unlock-other-seat": YES,
			"org.freedesktop.udisks2.eject-media-other-seat": YES,
			"org.freedesktop.udisks2.power-off-drive-other-seat": YES
		};
		if (subject.isInGroup("wheel")) {
			return permission[action.id];
		}
	});
	'';
	# Auto refresh nix-channel each day
	systemd.user.services.channel-update = {
		description = "Update nix-channel daily";
		wantedBy = [ "multi-user.target" ];
		serviceConfig = {
			Type = "oneshot";
			ExecStart = "/run/current-system/sw/bin/nix-channel --update";
			Environment = "PATH=/run/current-system/sw/bin";
		};
	};
	systemd.user.timers.channel-update = {
		description = "Update nix-channel daily";
		wantedBy = [ "timers.target" ];
		timerConfig = {
			OnCalendar = "daily";
			Persistent = "true";
		};
	};
	systemd.user.timers.channel-update.enable = true;
}
