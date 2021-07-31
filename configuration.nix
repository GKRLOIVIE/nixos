# Edit this configuration file to define what should be installed on 
# your system.  Help is available in the configuration.nix(5) man 
# page and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      #  ./wayland.nix
     # ./matrix.nix
    ];
  # swapDevices = [ { device = "/swapfile"; size = 2048; } ];
  
#Zram
zramSwap.enable = true;
zramSwap.memoryPercent = 200;

#EarlyOOM

services.earlyoom.enable = true;


services.auto-cpufreq.enable = true;

#Btrfs
services.btrfs.autoScrub.enable = true;
services.btrfs.autoScrub.interval = "weekly";

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "ntfs" ];
  #boot.kernelPackages = pkgs.linuxPackages_xanmod;
 # boot.kernelPackages = pkgs.linuxPackages_zen;
  boot.kernelPackages = pkgs.linuxPackages_lqx;
  boot.plymouth.enable = true;
  

  
   networking.hostName = "shahov-nix"; # Define your hostname.
   networking.networkmanager.enable = true;  # Enables wireless support via networkmanager.

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

  

   #Nvidia
   boot.blacklistedKernelModules = [ "nouveau" ];
   services.xserver.videoDrivers = [ "nvidia" ];
   
   #Vulkan
  hardware.opengl.enable = true;
  hardware.opengl.driSupport = true;	 
  hardware.opengl.driSupport32Bit = true;
  hardware.opengl.extraPackages32 = with pkgs.pkgsi686Linux;
    [ libva ]
    ++ lib.optionals config.services.pipewire.enable [ pipewire ];
  hardware.opengl.setLdLibraryPath = true;
  hardware.pulseaudio.support32Bit = true;
  

  #Xorg

  services.xserver.enable = true;
  #services.xserver.xkbModel = "pc87";
   
  # Enable Desktop Environment.
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "shahov";
  
#  services.xserver.windowManager.awesome.enable = true;
  #services.xserver.windowManager.awesome.package = [ awesome ];
 # services.xserver.windowManager.awesome.luaModules = [ pkgs.lua53Packages.vicious ];
  services.xserver.desktopManager.plasma5.enable = true;
  

  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable CUPS to print documents.
  #services.printing.enable = true;
  #services.printing.drivers = [];


  # Enable sound.
  
 # Remove sound.enable or turn it off if you had it set previously, it seems to cause conflicts with pipewire
#sound.enable = true;

# rtkit is optional but recommended
security.rtkit.enable = true;
 services.pipewire = {
  enable = true;
  alsa.enable = true;
  alsa.support32Bit = true;
  pulse.enable = true;
  # If you want to use JACK applications, uncomment this
  jack.enable = true;

  # use the example session manager (no others are packaged yet so this is enabled by default,
  # no need to redefine it in your config for now)
  #media-session.enable = true;
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
   
   #Doas
security.doas.enable = true;   
security.doas.extraRules = [{
    users = [ "shahov" ];
    keepEnv = true;
}];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  
   environment.systemPackages = with pkgs; [
   #Systemutils
killall
nano
appimage-run
neofetch
thefuck
softether
#Terminal
alacritty
#Java
jre8
#adoptopenjdk-jre-bin
jdk8
openjfx15



#Kde
latte-dock
plasma-applet-caffeine-plus
#libsForQt5.kwin-tiling
libsForQt5.kdeconnect-kde
libsForQt514.qtstyleplugin-kvantum
#libsForQt512.discover


#Files
ark
wget
unrar
zip
unzip

dolphin
mc
krusader

bleachbit

syncthing

# GUI for sound control
pavucontrol
qjackctl

# Office
libreoffice-qt
hunspell
hunspellDicts.en-us
hunspellDicts.ru-ru
mindforger
obsidian
#xfe

joplin-desktop
freemind
anki

#Network
firefox
torbrowser

kotatogram-desktop
element-desktop
mirage-im
nheko
fractal
#rambox
discord
betterdiscord-installer
qtox

#zoom-us

remmina
tigervnc
qbittorrent
webtorrent_desktop


#Audio
amarok
clementineUnfree
spotify
spotify-qt
#swaglyrics
ardour
lmms
sonic-pi
renoise

#Video
vlc
tartube

# Games
#wine-staging
#ajour
yuzu-ea
#Steam
legendary-gl
lutris
obs-studio
#adom
tome4

#nur.repos.mweinelt.trinitycore_335

#Art
qimgv
gwenview
okular
meshlab
cura
#nur.repos.tilpner.primitive
krita
gmic-qt-krita
inkscape

gparted
qdirstat

mtpfs
jmtpfs

(pidgin.override {
  plugins = [ pidginotr pidgin-xmpp-receipts purple-lurch purple-facebook  pidgin-window-merge purple-plugin-pack purple-matrix purple-discord telegram-purple purple-vk-plugin pidgin-opensteamworks ];  })

    lbry
    tangram
    newsflash
    michabo
    hydrus   
    tribler

    #Audio Visualizer
glava
projectm


   ];
   
   #Unfree
   nixpkgs.config.allowUnfree = true;
   
   #Broken
   nixpkgs.config.allowBroken = true;
   
   # unstable = import <nixos-unstable> {};
   
   #NUR
  nixpkgs.config.packageOverrides = pkgs: {
    nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
     inherit pkgs;
    };  
  };
 
  #Nix-community overlay
  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url = https://github.com/nix-community/emacs-overlay/archive/master.tar.gz;
    }))    
   ];


   
   
#LogMeIn Hamachi
#services.logmein-hamachi.enable = true;
   
 #Steam
programs.steam.enable = true;
hardware.steam-hardware.enable = true;

#Flatpak
services.flatpak.enable = true;
xdg.portal.enable = true;

#Gamemode
programs.gamemode.enable = true;

#Syncthing
services.syncthing.enable = true;

  #Emacs
 services.emacs.enable = true;
 #services.emacs.package = pkgs.emacsUnstable;
 services.emacs.package = with pkgs; (emacsWithPackages (with emacsPackagesNg; [
      evil
      nix-mode
      haskell-mode
     # python-mode
      #intero
      org
      sonic-pi
     # doom
      graphene
      graphene-meta-theme
      mastodon
      emms
  ]));

 
 
nixpkgs.config.firefox.enablePlasmaBrowserIntegration = true;

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
#hardware.bluetooth.package = "pkgs.bluezFull";

 
  system.stateVersion = "21.11"; 
  system.autoUpgrade.enable = true;
nix.gc = {
  automatic = true;
  dates = "weekly";
  options = "--delete-older-than 1d";
};

# Set limits for esync.
#systemd.extraConfig = "DefaultLimitNOFILE=1048576";

#security.pam.loginLimits = [{
 #   domain = "*";
 #   type = "hard";
 #   item = "nofile";
 #   value = "1048576";
#}];

# Select internationalisation properties.
   i18n.defaultLocale = "ru_RU.UTF-8";
   console = {
     font = "cyr-sun16";
     keyMap = "us";
   };

#Shell
# programs.zsh.ohMyZsh.theme = "romkatv/powerlevel10k";
programs.zsh = {
  enable = true;
  autosuggestions.enable = true;
  ohMyZsh.enable = true;
  ohMyZsh.plugins = [ " git dirhistory colorize emacs systemd thefuck zsh-interactive-cd web-search" ];
 ohMyZsh.theme = "fino-time";
 # ohMyZsh.theme = "powerline-go";
  syntaxHighlighting.enable = true;
};
  users.users.shahov = {
    shell = pkgs.zsh;
  };

  

}
