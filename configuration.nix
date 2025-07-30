{ config, lib, pkgs, ...}:
{ imports =
[	./hardware-configuration.nix
	./network.nix

	<home-manager/nixos>
	];

#################
#           	#
#      BOOT     #
#               #
#################

boot.loader.systemd-boot.enable = true;
boot.loader.efi.canTouchEfiVariables = true;
boot.supportedFilesystems = [ "ntfs" ];
fileSystems."/run/media/tomat/ntfs1" = {
	device = "/dev/nvme0n1p4";
	fsType = "ntfs-3g";
	options = ["rw" "uid=1000"];
};
fileSystems."/run/media/tomat/ntfs2" = {
	device = "/dev/nvme0n1p2";
	fsType = "ntfs-3g";
	options = ["rw" "uid=1000"];
};

#/###############\
##	         #
##      PKGS     #
##               #
#\###############/

nixpkgs.config.allowUnfree = true;
environment.systemPackages = with pkgs; [
	
	# audio
	wireplumber
	audacity
	pipewire
	pavucontrol
	ffmpeg
	vlc

	# video + photo
	gimp
	inkscape
	mpv
	mpvpaper
	plymouth
        nodePackages_latest.nodejs

	# hyprland
	xdg-desktop-portal-hyprland
	hyprshade
	eww
	networkmanagerapplet
	gammastep
	swaynotificationcenter
	hyprpaper
	waybar
	hyprland
	wayland
	hyprlang
	hyprcursor
	hyprutils
	egl-wayland
	birdtray
	wofi
	helix

	# Qt5
	libsForQt5.qt5.qtwayland
	libsForQt5.ffmpegthumbs
	libsForQt5.kio-extras
	libsForQt5.xwaylandvideobridge
	ffmpegthumbnailer
	webp-pixbuf-loader

	# gui apps
	prismlauncher
	floorp
	libreoffice-still
	steam
	freecad-wayland
	keepassxc
	keepassxc-go
	steam-run
	steam-unwrapped
	kicad
	vesktop
	xarchiver
	virtualbox
	bleachbit
	thunderbird-esr
	gparted
	alacritty

	# wine
	vinegar
	wineWowPackages.stable
	wineWowPackages.waylandFull
	winetricks
	
	# pro gramming
	rustup
	rar
	unrar
	zip
	unzip
	python3Full
	vim
	neovim
	audacity
	wget
	curl
	git-credential-keepassxc
	gcc_multi
	llvm
	ntfs3g
	gitFull
	zig
	ninja
	autoconf
	gnumake
	cmake
	ripgrep
	libtool
	libgsf

	# securitat
	fail2ban
	htop
	nvtopPackages.full
	pam
	rtkit
	polkit
	zerotierone
	zeronsd
	avahi
	dconf
	zsh
	cryptsetup
	
	# cli apps
	cli-visualizer
	fftw
	cachix
	udiskie
	neofetch
	lolcat
	figlet
	cowsay
	fortune
	steam-tui
	ly
	mpd
	aquamarine
	asciiquarium-transparent
	p7zip
	cmatrix

	# nvidia, fuck nvidia
	nvidia-vaapi-driver
];

#*\_#####################
#|		        #
#         SER-VICES     #
#|	                #
#*\_#####################

# OpenGL
	hardware.graphics = {
		enable = true;
	};
# NVIDIA FUCK YOU
	services.xserver.videoDrivers = ["nvidia"];
	boot.initrd.kernelModules = ["nvidia"];
	hardware.nvidia = {
		modesetting.enable = true;
		open = false;
		package = config.boot.kernelPackages.nvidiaPackages.stable;
		nvidiaSettings = true;
		powerManagement.enable = false;
		powerManagement.finegrained = false;
	};

environment.sessionVariables.NIXOS_OZONE_WL = "1";


# Font + ZSH

fonts.packages = with pkgs; [
	noto-fonts
	ncurses
	noto-fonts-emoji
	nerd-fonts.blex-mono
	nerd-fonts.code-new-roman
];
users.defaultUserShell = pkgs.zsh;

# fail2ban
services.fail2ban = {
	enable = true;
	maxretry = 3;
	bantime = "48h";
};

# OpenSSH
services.openssh = {
	enable = true;
	ports = [ 22 ];
	settings = {
		PasswordAuthentication = true;
		AllowUsers = null;
		UseDns = true;
		PermitRootLogin = "no";
	};
};

# SOUND
services.pipewire = {
  enable = true;
  pulse.enable = true;
  alsa.enable = true;
  alsa.support32Bit = true;
  jack.enable = true;
};

# HP TY KURWO JEBANA PRZESTAŃ MI LINUXA PRZEŚLADOWAĆ
services.printing.enable = true;

# Locale
time.timeZone = "Europe/Warsaw";
i18n.defaultLocale = "en_GB.UTF-8";
fonts.fontDir.enable = true;
console = {
  font = "Lat2-Terminus20";
  keyMap = "pl";
};

# Enable
## security
security.polkit.enable = true;
security.rtkit.enable = true;

## programs
programs.zsh.enable = true;
programs.mtr.enable = true;
programs.gnupg.agent = {
  enable = true;
  enableSSHSupport = true;
};
programs.firefox.enable = true;
programs.hyprland = {
  enable = true;
  xwayland.enable = true;
};
programs.steam = {
  enable = true;
  remotePlay.openFirewall = false;
  dedicatedServer.openFirewall = true;
  localNetworkGameTransfers.openFirewall = true;
};
programs.neovim.enable = true;
programs.git.enable = true;
programs.xfconf.enable = true;
programs.thunar = {
  enable = true;
  plugins = with pkgs.xfce; [
  thunar-archive-plugin
  thunar-volman
  ];
};

## services
services.gvfs.enable = true;
services.tumbler.enable = true;
services.samba.enable = true;
services.flatpak.enable = true;

services.zerotierone.enable = true;
networking.firewall.trustedInterfaces = ["ztpin53bn3"];
services.avahi = {
	enable = true;
	interfaces = ["ztpin53bn3"];
	ipv6 = true;
	publish.enable = true;
	publish.userServices = true;
	publish.addresses = true;
	publish.domain = true;
	nssmdns = true;
	publish.workstation = true;
};

## virtualize android for TD2DR
virtualisation.waydroid.enable = true;

##  USER  ##

users.users.tomat = {
  isNormalUser = true;
  extraGroups = [ "wheel" ];
};

#######################
#        FLAKES	      #
#######################

nix.settings.experimental-features = ["nix-command" "flakes"];


##	 !!!!! DO NOT TOUCH!!!!!  	##
system.stateVersion = "24.11";
system.copySystemConfiguration = true;
}
