{ lib, ... }:
{
  # Define system hostname
  networking.hostName = "framework";

  # Enable ROCM support
  nixpkgs.config.rocmSupport = true;

  # Extend timeout of home-manager service so it doesn't fail
  systemd.services.home-manager-radioaddition.serviceConfig.TimeoutStartSec = lib.mkForce 600;

  # Enable fingerprint reader support
  services.fprintd.enable = true;

  # Improve sound quality
  hardware.framework.laptop13.audioEnhancement = {
    enable = true;
    # Turn base speaker volume up to max before applying this
    hideRawDevice = false;
  };
}
