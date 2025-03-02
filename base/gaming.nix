{
  pkgs,
  lib,
  inputs,
  ...
}:
{
  imports = [ inputs.jovian.nixosModules.jovian ];

  ## Steam
  programs.steam = {
    enable = true;
    localNetworkGameTransfers.openFirewall = true;
    dedicatedServer.openFirewall = true;
    remotePlay.openFirewall = true;
    gamescopeSession.enable = true;
  };

  # Drivers and Stuff(TM)
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  services.xserver.videoDrivers = [ "amdgpu" ];
  hardware.steam-hardware.enable = true;

  programs.gamescope.enable = true;
  programs.java.enable = true;
  environment.systemPackages = with pkgs; [
    mangohud
    protonplus
    adwsteamgtk
  ];

  jovian = {
    steam = {
      enable = true;
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

  specialisation.gaming-mode.configuration = {
    imports = [ inputs.jovian.nixosModules.jovian ];

    # Disable usbguard in gaming mode for controllers
    services.usbguard.enable = lib.mkForce false;

    # Switch to a more perfomant secure memory allocator
    environment.memoryAllocator.provider = lib.mkForce "scudo";
    environment.variables.SCUDO_OPTIONS = "ZeroContents=1";

    # Disable kernel hardening in gaming mode for performance
    boot.kernelParams = lib.mkForce [
      "debugfs=off"
      "init_on_alloc=1"
      "iommu.passthrough=0"
      "iommu.strict=1"
      "iommu=force"
      "kvm-intel.vmentry_l1d_flush=always"
      "l1d_flush=on"
      "lockdown=confidentiality"
      "mitigations=auto,nosmt"
      "module.sig_enforce=1"
      "page_alloc.shuffle=1"
      "page_poison=1"
      "pti=auto"
      "random.trust_bootloader=off"
      "random.trust_cpu=off"
      "randomize_kstack_offset=on"
      "slab_nomerge"
      "spec_store_bypass_disable=auto"
      "spectre_v2=on"
      "vsyscall=xonly"
    ];

    # Disable gdm so that jovian autostart will work
    services.xserver.displayManager.gdm.enable = lib.mkForce false;

    jovian.steam = {
      autoStart = true;
      desktopSession = "gnome";
    };

  };
}
