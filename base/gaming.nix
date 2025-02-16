{
  pkgs,
  lib,
  inputs,
  ...
}:
{
  specialisation.gaming-mode.configuration = {
    imports = [ inputs.jovian.nixosModules.jovian ];
    # Disable kernel hardening in gaming mode for performance
    boot.kernelParams = lib.mkForce [ ];

    # Disable gdm so that jovian autostart will work
    # services.xserver.displayManager.gdm.enable = lib.mkForce false;
    # OpenGL
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };
    services.xserver.videoDrivers = [ "amdgpu" ];

    ## Steam
    programs.steam = {
      enable = true;
      extraCompatPackages = with pkgs; [ proton-ge-bin ];
      localNetworkGameTransfers.openFirewall = true;
      dedicatedServer.openFirewall = true;
      remotePlay.openFirewall = true;
      gamescopeSession.enable = true;
    };
    programs.gamescope.enable = true;
    programs.java.enable = true;
    environment.systemPackages = with pkgs; [
      mangohud
    ];
    jovian = {
      steam = {
        enable = true;
        # autoStart = true;
        # desktopSession = "gnome";
        updater.splash = "vendor";
        user = "radioaddition";
      };
      devices.steamdeck.enable = false;
      decky-loader.enable = true;
      steamos = {
        useSteamOSConfig = true;
        enableZram = false;
        enableProductSerialAccess = false;
      };
      # steamos.enableMesaPatches = false;
      hardware.has.amd.gpu = true;
    };
  };
}
