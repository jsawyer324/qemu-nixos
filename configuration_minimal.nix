{ config, pkgs, lib, ... }:

{
  imports = [
		./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

	networking = {
		hostName = "nixoshost";
		networkmanager.enable = true;
		firewall.enable = false;
	};

  environment.etc = {
		
  };	


  time.timeZone = "America/Chicago";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
		LC_ADDRESS = "en_US.UTF-8";
		LC_IDENTIFICATION = "en_US.UTF-8";
		LC_MEASUREMENT = "en_US.UTF-8";
		LC_MONETARY = "en_US.UTF-8";
		LC_NAME = "en_US.UTF-8";
		LC_NUMERIC = "en_US.UTF-8";
		LC_PAPER = "en_US.UTF-8";
		LC_TELEPHONE = "en_US.UTF-8";
		LC_TIME = "en_US.UTF-8";
  };


	services = {
		
		xserver = {
			enable = true;
			displayManager.lightdm.enable = true;
			desktopManager.xfce.enable = true;
			xkb = {
				layout = "us";
				variant = "";
			};
  	};

		# pipewire = {
		# 	enable = true;
		# 	alsa.enable = true;
		# 	alsa.support32Bit = true;
		# 	pulse.enable = true;
		# };

		spice-vdagentd.enable = true;
		qemuGuest.enable = true;	

	};

  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;

  users.users.james = {
    	isNormalUser = true;
    	initialPassword = "password";
    	description = "james";
    	extraGroups = [ "networkmanager" "wheel" ];
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
  ];

  system.stateVersion = "24.11"; # Did you read the comment?
}
