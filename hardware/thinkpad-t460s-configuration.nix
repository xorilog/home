{ config, pkgs, ... }:

{

	services = {
		acpid = {
			enable = true;
			lidEventCommands = ''
if grep -q closed /proc/acpi/button/lid/LID/state; then
	date >> /tmp/i3lock.log
	DISPLAY=":0.0" XAUTHORITY=/home/fadenb/.Xauthority ${pkgs.i3lock}/bin/i3lock &>> /tmp/i3lock.log
fi
'';
		};
		tlp = {
			enable = true;
			extraConfig = ''
# CPU optimizations
CPU_SCALING_GOVERNOR_ON_AC=performance
CPU_SCALING_GOVERNOR_ON_BAT=powersave
CPU_MIN_PERF_ON_AC=0
CPU_MAX_PERF_ON_AC=100
CPU_MIN_PERF_ON_BAT=0
CPU_MAX_PERF_ON_BAT=50
# DEVICES (wifi, ..)
DEVICES_TO_DISABLE_ON_STARTUP="wifi wwan"
DEVICES_TO_ENABLE_ON_AC="bluetooth wifi wwan"
DEVICES_TO_DISABLE_ON_BAT="bluetooth"
# Network management
DEVICES_TO_DISABLE_ON_LAN_CONNECT="wifi wwan"
DEVICES_TO_DISABLE_ON_WIFI_CONNECT=""
DEVICES_TO_DISABLE_ON_WWAN_CONNECT=""
DEVICES_TO_ENABLE_ON_LAN_DISCONNECT="wifi wwan"
DEVICES_TO_ENABLE_ON_WIFI_DISCONNECT=""
DEVICES_TO_ENABLE_ON_WWAN_DISCONNECT="" 
# Make sure it uses the right hard drive
DISK_DEVICES="nvme0n1p3"
			'';
		};
	};
	services.xserver = {
			synaptics.enable = false;

			 config = ''
      			 Section "InputClass"
			         Identifier     "Enable libinput for TrackPoint"
				 MatchIsPointer "on"
				 Driver         "libinput"
				 Option         "ScrollMethod" "button"
				 Option         "ScrollButton" "8"
			 EndSection
    			 '';
			inputClassSections = [
					''
					Identifier "evdev touchpad off"
					MatchIsTouchpad "on"
					MatchDevicePath "/dev/input/event*"
					Driver "evdev"
					Option "Ignore" "true"
					''
			];
	};
	
	boot.extraModprobeConfig = ''
	options snd_hda_intel power_save=1
	# options i915 enable_rc6=0
	'';
}
