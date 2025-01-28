{
  config,
  pkgs,
  inputs,
  unstable,
  lib,
  ...
}:
#let
#  unstable = inputs.unstable.legacyPackages."${pkgs.system}";
#
#  #unstable = import inputs.unstable {
#  #  system = "${pkgs.system}";
#  #  config.allowUnfree = true;
#  #};
#in
{
  # Compatability with my existing configuration
  disabledModules = [
    "config/pulseaudio.nix"
    "programs/steam.nix"
  ];
  imports = [
    "${inputs.unstable}/nixos/modules/services/audio/pulseaudio.nix"
    "${inputs.unstable}/nixos/modules/programs/steam.nix"
    inputs.jovian-nixos.nixosModules.default
  ];
  networking.networkmanager.enable = lib.mkForce true;
  ## Steam
  programs.steam = {
    enable = true;
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
    localNetworkGameTransfers.openFirewall = true;
    dedicatedServer.openFirewall = true;
    remotePlay.openFirewall = true;
    gamescopeSession.enable = true;
    extest.enable = true;
    package = unstable.steam;
  };
  programs.gamescope.enable = true;
  programs.java.enable = true;
  hardware.openrazer.enable = true;
  environment.systemPackages = with pkgs; [
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
    hardware.has.amd.gpu = true;
  };
}
