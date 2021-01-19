# Edit this configuration file to define what should be installed on 
# your system.  Help is available in the configuration.nix(5) man 
# page and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "ntfs" ];
  boot.blacklistedKernelModules = [ "nouveau" ];
 

   networking.hostName = "shahov-nix"; # Define your hostname.
   networking.networkmanager.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  time.timeZone = "Europe/Moscow";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.

  #networking.useDHCP = false;
  #networking.interfaces.enp0s10.useDHCP = true;
  #networking.interfaces.wlp3s0b1.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
   i18n.defaultLocale = "ru_RU.UTF-8";
   console = {
     font = "cyr-sun16";
     keyMap = "us";
   };

   #Nvidia
   services.xserver.videoDrivers = [ "nvidia" ];
# Vulkan 
 hardware.opengl.driSupport32Bit = true;
  hardware.opengl.enable = true;
  hardware.pulseaudio.support32Bit = true;
  hardware.opengl.driSupport = true;

#xorg 
   services.xserver.enable = true;
  # Enable the Plasma 5 Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "shahov";
 # services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
 # services.xserver.windowManager.exwm.enable = true;

  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable CUPS to print documents.
   #services.printing.enable = true;
  #services.printing.drivers = [];
  # Enable sound.
   sound.enable = true;
   hardware.pulseaudio.enable = false;
services.jack = {
    jackd.enable = true;
    # support ALSA only programs via ALSA JACK PCM plugin
    alsa.enable = false;
    # support ALSA only programs via loopback device (supports programs like Steam)
    loopback = {
      enable = true;
      # buffering parameters for dmix device to work with ALSA only semi-professional sound programs
      #dmixConfig = ''
      #  period_size 2048
      #'';
    };
  };

  users.extraUsers.shahov.extraGroups = [ "jackaudio" ]; 

  # Enable touchpad support (enabled default in most desktopManager).
   services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
   users.users.shahov = {
     isNormalUser = true;
     extraGroups = [ "wheel audio networkmanager" ]; # Enable ‘sudo’ for the user.
     home = "/home/shahov";
       description = "Anatolii Shahov";
   };
security.sudo.configFile = ''%wheel ALL=(ALL) ALL'';
  # List packages installed in system profile. To search, run:
  # $ nix search wget
   environment.systemPackages = with pkgs; [
   # systemutils
bash
coreutils
binutils
killall
sudo
doas
nano
vim
#files
ark
wget
unrar
zip
unzip
# GUI for sound control
#pavucontrol
qjackctl
#Terminal
alacritty
# office
dolphin
kdeApplications.okular
emacs26
emacs26Packages.doom
sonic-pi
emacs26Packages.sonic-pi
# network
firefox
tdesktop
discord
zoom-us
# games
# wine-staging
#wineWowPackages.stable
#wineWowPackages.staging
lutris-unwrapped
vulkan-loader
vulkan-tools
steam
libreoffice-fresh
#Audio
ardour
lmms

   ];
nixpkgs.config.allowUnfree = true;

  nixpkgs.config.packageOverrides = pkgs: {
    nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
      inherit pkgs;
    };
  };

 users.users.shahov.packages = with pkgs; [
   (wineWowPackages.full.override {
     wineRelease = "staging";
     mingwSupport = true;
   })
   (winetricks.override {
     wine = wineWowPackages.staging;
   })
 ];

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
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

# Bluetooth
hardware.bluetooth.enable = true;
services.blueman.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?
  system.autoUpgrade.enable = true;
nix.gc = {
  automatic = true;
  dates = "weekly";
  options = "--delete-older-than 30d";
};


 
  programs.fish.enable = true;

  users.users.foo = {
    shell = pkgs.fish;
  };
  

}
