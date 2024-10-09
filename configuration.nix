# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  #services.xserver.resolutions = lib.mkOverride 0 [{ x = 1920; y = 1153; }];
  #services.xserver.virtualScreen = { x = 1920; y = 1153; };

  # Enable networking
  networking.networkmanager.enable = true;
  #systemd.network.enable = true;
  services.networkd-dispatcher.enable = true;
  environment.etc = {
  # Creates /etc/nanorc
  "NetworkManager/dispatcher.d/10-routes.sh" = {
      text = ''
        ip route add 192.168.1.0/24 via 10.0.2.2
      '';

      # The UNIX file mode bits
      mode = "0700";
    };
  };	
  #networking.interfaces.enp1s0.ipv4.routes = [
  #	{
  #  	  address = "192.168.1.0";
  #  	  prefixLength = 24;
  #  	  via = "10.0.2.2";
  #	}
  #];	 

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

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  #services.displayManager.sddm.enable = true;
  #services.desktopManager.plasma6.enable = true;

  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.xfce.enable = true; 

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  services.spice-vdagentd.enable = true;
  services.qemuGuest.enable = true;
  #virtualisation.qemu.options = [
	#"disable-copy-paste=off"
  #];	



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

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

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

  # Install firefox.
  #programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
	#git
	brave
	networkmanager-openvpn
	nfs-utils
	cifs-utils
	session-desktop
	spice-vdagent
	spice-autorandr  
	numlockx  
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

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  #networking.firewall.allowedUDPPorts = [ 53 1194 ];
  #networking.firewall.interfaces."enp1s0".allowedTCPPorts = [ 53 1194 ];
  #networking.firewall.interfaces."tun0".allowedTCPPorts = [ 80 443 ];
  # Or disable the firewall altogether.
  networking.firewall.enable = true;

  networking.firewall.extraCommands = ''
  	#iptables -A nixos-fw -p tcp --source 192.0.2.0/24 --dport 1714:1764 -j nixos-fw-accept || true
  	#iptables -A nixos-fw -p udp --source 192.0.2.0/24 --dport 1714:1764 -j nixos-fw-accept || true
	
	#Allow loopback device (internal communication)
	iptables -A INPUT -i lo -j ACCEPT
	iptables -A OUTPUT -o lo -j ACCEPT

	#Allow all local traffic.
	iptables -A INPUT -s 192.168.1.0/24 -j ACCEPT
	iptables -A OUTPUT -d 192.168.1.0/24 -j ACCEPT

	#Allow VPN establishment
	iptables -A OUTPUT -p udp --match multiport --dports 53,1194 -j ACCEPT
	iptables -A INPUT -p udp --match multiport --sports 53,1194 -j ACCEPT

	#Accept all TUN connections (tun = VPN tunnel)
	iptables -A OUTPUT -o tun+ -j ACCEPT
	iptables -A INPUT -i tun+ -j ACCEPT

	#Set default policies to drop all communication unless specifically allowed
	iptables -P INPUT DROP
	iptables -P OUTPUT DROP
	iptables -P FORWARD DROP  
  '';

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}
