{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        #device = "/dev/some-disk"; # Make sure to specify this if not using disko-install
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              name = "ESP";
              size = "2G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            root = {
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = [ "-f" ]; # Override existing partition
                subvolumes = {
                  "root" = {
                    mountpoint = "/";
                    mountOptions = [
                      "relatime"
                      "compress=zstd"
                    ];
                  };
                  "nix" = {
                    mountpoint = "/nix";
                    mountOptions = [
                      "relatime"
                      "compress=zstd"
                    ];
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
