	{ config, lib, pkgs, ...}:
	{
	networking.hostName = "Nixiarz";	
	networking.wireless.enable = false;
	networking.networkmanager.enable = true;
}
