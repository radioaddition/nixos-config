{ ... }:
{
  boot.initrd.luks.devices."crypted" = {
    device = "/dev/disk/by-partlabel/disk-main-luks";
    crypttabExtraOpts = [
      "fido2-device=auto"
      "tpm2-device=auto"
      "tpm2-measure-pcr=yes"
    ];
  };

  fileSystems."/" = {
    device = "/dev/mapper/crypted";
    neededForBoot = true;
    fsType = "btrfs";
    options = [
      "subvol=root"
      "compress=zstd"
      "nosuid"
    ];
  };

  fileSystems."/home" = {
    device = "/dev/mapper/crypted";
    neededForBoot = true;
    fsType = "btrfs";
    options = [
      "subvol=home"
      "compress=zstd"
      "nosuid"
    ];
  };

  fileSystems."/nix" = {
    device = "/dev/mapper/crypted";
    fsType = "btrfs";
    options = [
      "subvol=nix"
      "compress=zstd"
    ];
  };

  zramSwap.enable = true;
  #fileSystems."/swap" = {
  #  device = "/dev/mapper/crypted";
  #  fsType = "btrfs";
  #  options = [
  #    "subvol=swap"
  #    "compress=zstd"
  #    "noexec"
  #    "nosuid"
  #  ];
  #};
  #swapDevices = [
  #  {
  #    device = lib.mkForce "/swap/swapfile";
  #    label = "swap";
  #    size = 32768;
  #  }
  #];

  fileSystems."/boot" = {
    device = "/dev/disk/by-partlabel/disk-main-ESP";
    fsType = "vfat";
  };
}
