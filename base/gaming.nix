{
  pkgs,
  inputs,
  unstable,
  lib,
  ...
}:
{
  # Disable kernel hardening in gaming mode for performance
  boot.kernelParams = lib.mkForce [ ];
  ## Steam
  programs.steam = {
    enable = true;
    extraCompatPackages = with unstable; [ proton-ge-bin ];
    localNetworkGameTransfers.openFirewall = true;
    dedicatedServer.openFirewall = true;
    remotePlay.openFirewall = true;
    gamescopeSession.enable = true;
    package = unstable.steam;
  };
  programs.gamescope = {
    enable = true;
    package = unstable.gamescope;
  };
  programs.java = {
    enable = true;
    package = unstable.jdk;
  };
  hardware.openrazer.enable = true;
  environment.systemPackages = with unstable; [
    openrazer-daemon
    polychromatic
  ];

  # Jovian
  #jovian = {
  #  steam = {
  #    enable = true;
  #    #autoStart = true;
  #    desktopSession = "gdm";
  #    updater.splash = "jovian";
  #    user = "radioaddition";
  #  };
  #  devices.steamdeck.enable = false;
  #  decky-loader.enable = true;
  #  steamos.useSteamOSConfig = false;
  #  #steamos.enableMesaPatches = false;
  #  hardware.has.amd.gpu = true;
  #};
}
