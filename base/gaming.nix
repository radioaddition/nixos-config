{
  pkgs,
  inputs,
  gaming,
  lib,
  ...
}: {
  # Disable kernel hardening in gaming mode for performance
  boot.kernelParams = lib.mkForce [];
  # Compatability with my existing configuration
  disabledModules = [
    "config/pulseaudio.nix"
    "hardware/openrazer.nix"
    #"programs/steam.nix"
  ];
  imports = [
    "${inputs.jovian-unstable}/nixos/modules/services/audio/pulseaudio.nix"
    "${inputs.jovian-unstable}/nixos/modules/hardware/openrazer.nix"
    #"${inputs.jovian-unstable}/nixos/modules/programs/steam.nix"
    inputs.jovian-nixos.nixosModules.default
  ];
  networking.networkmanager = lib.mkForce {
    enable = true;
    wifi.backend = "iwd";
  };
  ## Steam
  programs.steam = {
    enable = true;
    extraCompatPackages = with gaming; [
      proton-ge-bin
    ];
    localNetworkGameTransfers.openFirewall = true;
    dedicatedServer.openFirewall = true;
    remotePlay.openFirewall = true;
    gamescopeSession.enable = true;
    extest.enable = true;
    package = gaming.steam;
  };
  programs.gamescope = {
    enable = true;
    package = gaming.gamescope;
  };
  programs.java = {
    enable = true;
    package = gaming.jdk;
  };
  hardware.openrazer.enable = true;
  environment.systemPackages = with gaming; [
    openrazer-daemon
    polychromatic
  ];

  # Jovian
  jovian = {
    steam = {
      enable = true;
      #autoStart = true;
      desktopSession = "gdm";
      updater.splash = "jovian";
      user = "radioaddition";
    };
    devices.steamdeck.enable = false;
    decky-loader.enable = true;
    steamos.useSteamOSConfig = true;
    steamos.enableMesaPatches = false;
    hardware.has.amd.gpu = true;
  };
}
