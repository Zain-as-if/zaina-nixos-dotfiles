{ config, pkgs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
 
  security.polkit.enable = true;
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.login.enableGnomeKeyring = true;
  security.pam.services.sddm.enableGnomeKeyring = true;

  # Enable networking
  networking.networkmanager.enable = true;
  networking.wireless.enable = true;
  networking.hostName = "zaina";
  
  networking.networkmanager.ensureProfiles.profiles = {
      eduroam = {
        connection = {
	  id = "eduroam";
	  type = "wifi";
	  interface-name = "wlp2s0";
	  autoconnect = true;
	};
	wifi = {
          mode = "infrastructure";
	  ssid = "eduroam";
	};
	wifi-security = {
          key-mgmt = "wpa-eap";
	};
	"802-1x" = {
          eap = "peap";
	  identity = "U2584774@hud.ac.uk";
	  ca-cert = "/etc/ssl/certs/ca-certificates.crt";
          phase2-auth = "mschapv2";
	};
	ipv4 = {
          method = "auto";
	};
	ipv6 = {
          method = "auto";
	};
      };
  };

  # Set your time zone.
  time.timeZone = "Europe/London";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

  # Disables the lightdm login manager than PAM uses
  services.xserver.displayManager.lightdm.enable = false;
  
  # Enables sddm 
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };
  
  # Enable the KDE Plasma Desktop Environment.
  services.desktopManager.plasma6.enable = true;
  programs.ssh.askPassword = lib.mkForce "${pkgs.seahorse}/libexec/seahorse/ssh-askpass";

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "gb";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "uk";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
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
	
  # Experimental Nix Features
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Ensure that the group for the user exists
  users.groups.zaina = {};

  # Enable the OpenSSH daemon.
  services.openssh = {
  	enable = true;
	settings = {
		PasswordAuthentication = false;
		PermitRootLogin = "no";
	};
  };

  # Enable Bluetooth
  hardware.bluetooth.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.zaina = {
    isNormalUser = true;
    group = "zaina"; # Ensure your user has a group
    shell = pkgs.zsh; # Set zsh as user's default shell
    description = "Zain Asif";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      kdePackages.kate
    #  thunderbird
    ];  
    # ssh authentication key
    openssh.authorizedKeys.keys = [
    	"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGDYtVg9vkekXkG2qHSMCJStPDjBZpJ2lszFPm6iKIkv arch-wsl" # Arch PC
	"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEkG2r47qkyn8jB7OKJsJy2vJOtgFrm9lWFTyvqDNSvD zain@Zain" # Powershell PC
    ];
  };

  # Program Enables
  programs.firefox.enable = true;
  programs.zsh.enable = true;  
  programs.bash.enable = true;
  programs.seahorse.enable = true;
  programs.zoxide.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
     vim
     wget
     git
     kitty
     unzip
     seahorse
     gnome-keyring
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];
  
  # HYPRLAND
  programs.hyprland = {
  	enable = true;
	withUWSM = true;
	xwayland.enable = true;
  };

  # Screensharing with hyprland
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ 
      xdg-desktop-portal-hyprland 
    ];
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Open ports in the firewall.
  # 22 for ssh
  networking.firewall.allowedTCPPorts = [ 22 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

}
