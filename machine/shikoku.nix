{ config, pkgs, ... }:

{
	imports =
		[ # Include the results of the hardware scan.
			../hardware-configuration.nix
			../configuration/custom-packages.nix
			../configuration/common.nix
			../profiles/ssh.nix
			../profiles/desktop.nix
			../profiles/audio.nix
			../profiles/dev.nix
			../profiles/virtualization.nix
			../profiles/dockerization.nix
			../profiles/office.nix
			../profiles/gaming.nix
			../profiles/synergy-server.nix
			../location/home.nix
			../service/ssh-tunnel.nix
		];

	time.timeZone = "Europe/Paris";
	boot.loader.systemd-boot.enable = true;

	services = {
		xserver = {
			videoDrivers = [ "nvidia" ];
			displayManager = {
				sessionCommands = ''
xrandr --output DP-2 --auto --left-of DP-4 --output DP-4 --auto &
'';
				slim.theme = pkgs.fetchurl {
					url = "https://github.com/vdemeester/slim-themes/raw/master/docker-nuage-theme-0.1.tar.xz";
					sha256 = "1ds7p3d8dn21bankgs68i53hqrj4d2abpk437h6dbjz36q1ys839";
				};
			};
		};
	};

	hardware.bluetooth.enable = true;

	environment.etc."synergy-server.conf" = { text = ''
section: screens
	shikoku:
	honshu:
	wakasu:
end
section: links
	shikoku:
		left = wakasu
	honshu:
		right = wakasu
        wakasu:
		right = shikoku
		left = honshu
end
section: options
	keystroke(super+shift+left) = switchInDirection(left)
	keystroke(super+shift+right) = switchInDirection(right)
end
''; };
}
