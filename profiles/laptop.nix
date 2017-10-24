# Common configuration for any laptops

{ configs, pkgs, ...}:

{
	imports = [
		./audio.nix
		./desktop.nix
	];

	environment.systemPackages = with pkgs; [
		acpi
		lm_sensors
		powertop
	];
}
