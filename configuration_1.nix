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

		firewall = {
			enable = false;
			extraCommands = ''

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
		};

	};

	environment.etc = {

		"NetworkManager/dispatcher.d/10-routes.sh" = {
			text = ''
				ip route add 192.168.1.0/24 via 10.0.2.2
			'';
			mode = "0700";
		};

		"X11/xorg.conf.d/10-monitor.conf" = {
			text = ''
				Section "Monitor"
				Identifier "Virtual-1"
				Modeline "1920x1153_60.00"  184.75  1920 2048 2248 2576  1153 1156 1166 1196 -hsync +vsync
				Option "PreferredMode" "1920x1153_60.00"
				EndSection
			'';
			mode = "0660";
		};

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

		pipewire = {
			enable = true;
			alsa.enable = true;
			alsa.support32Bit = true;
			pulse.enable = true;
		};

		spice-vdagentd.enable = true;
		qemuGuest.enable = true;
		networkd-dispatcher.enable = true;
		openssh.enable = true;		# Enable the OpenSSH daemon.
		samba.enable = true;    	# Enable the Samba daemon.
		gvfs.enable = true;     	# Mount, trash, and other functionalities
		tumbler.enable = true;  	# Thumbnail support for images

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
		brave
		networkmanager-openvpn
		nfs-utils
		cifs-utils
		session-desktop
		numlockx
		mesa
	];

	programs.git = {
		enable = true;
		config = {
				user.name = "James Sawyer";
				user.email = "jsawyer324@gmail.com";
		};
	};

	fileSystems."/home/james/nas" = {
		device = "//192.168.1.14/Media2$";
		fsType = "cifs";
		options = let
			automount_opts = "dir_mode=0777,file_mode=0666,noperm";
		in ["credentials=/etc/nixos/smb-secrets,${automount_opts}"];
	};

	environment = {
		etc."nixos/smb-credentials" = {
			mode = "0644";
			text = ''
				username=jsawyer
				password=cifs_password
			'';
		};
	};

	system.stateVersion = "24.11"; # Did you read the comment?
}
