{
  pkgs,
  inputs,
  unstable,
  lib,
  ...
}:
{
  specialisation.gaming-mode.configuration = {
    # Disable kernel hardening in gaming mode for performance
    boot.kernelParams = lib.mkForce [ ];

    # OpenGL
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };
    services.xserver.videoDrivers = ["amdgpu"];

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
    programs.java.enable = true;
    environment.systemPackages = with unstable; [
      mangohud
    ];
  };
}
