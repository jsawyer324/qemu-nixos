# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.

  # Enable networking
  networking.networkmanager.enable = true;
  services.networkd-dispatcher.enable = true;
	
  networking.interfaces.enp1s0.ipv4.routes = [
  	{
    	  address = "192.168.1.0";
    	  prefixLength = 24;
    	  via = "10.0.2.2";
  	}
  ];	 

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Select internationalisation properties.
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


  services.xserver.enable = true;
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.xfce.enable = true; 
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };


  services.spice-vdagentd.enable = true;
  services.qemuGuest.enable = true;


  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };


  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.james = {
    isNormalUser = true;
    description = "james";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      kdePackages.kate
    #  thunderbird
    ];
  };



  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;


  environment.systemPackages = with pkgs; [
    	brave
    	networkmanager-openvpn
    	nfs-utils
    	cifs-utils
    	session-desktop
    	spice-vdagent
    	spice-autorandr  
  ];

   programs.git = {
     	enable = true;
     	config = {
      		user.name = "James Sawyer";
      		user.email = "jsawyer324@gmail.com";
    	};
   };
    
   services = {
    	samba.enable = true;    # Enable the Samba daemon.
    	gvfs.enable = true;     # Mount, trash, and other functionalities
    	tumbler.enable = true;  # Thumbnail support for images
   };


  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;


  networking.firewall.enable = true;

  networking.firewall.extraCommands = ''
  	#iptables -A nixos-fw -p tcp --source 192.0.2.0/24 --dport 1714:1764 -j nixos-fw-accept || true
  	#iptables -A nixos-fw -p udp --source 192.0.2.0/24 --dport 1714:1764 -j nixos-fw-accept || true
	
    	#Allow loopback device (internal communication)
    	iptables -A INPUT -i lo -j ACCEPT || true
    	iptables -A OUTPUT -o lo -j ACCEPT || true
    
    	#Allow all local traffic.
    	iptables -A INPUT -s 192.168.1.0/24 -j ACCEPT || true
    	iptables -A OUTPUT -d 192.168.1.0/24 -j ACCEPT || true
    
    	#Allow VPN establishment
    	iptables -A OUTPUT -p udp --match multiport --dports 53,1194 -j ACCEPT || true
    	iptables -A INPUT -p udp --match multiport --sports 53,1194 -j ACCEPT || true
    
    	#Accept all TUN connections (tun = VPN tunnel)
    	iptables -A OUTPUT -o tun+ -j ACCEPT || true
    	iptables -A INPUT -i tun+ -j ACCEPT || true
    
    	#Set default policies to drop all communication unless specifically allowed
    	iptables -P INPUT DROP || true
    	iptables -P OUTPUT DROP || true
    	iptables -P FORWARD DROP || true
  '';


  system.stateVersion = "24.05"; # Did you read the comment?

}
