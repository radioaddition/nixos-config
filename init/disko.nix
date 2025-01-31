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
              size = "10G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            luks = {
              size = "100%";
              content = {
                type = "luks";
                name = "crypted";
                #passwordFile = "/tmp/passwordfile";
                settings.allowDiscards = true;
                content = {
                  type = "btrfs";
                  extraArgs = [ "-f" ];
                  subvolumes = {
                    "root" = {
                      mountpoint = "/";
                      mountOptions = [
                        "compress=zstd"
                        "relatime"
                        "nosuid"
                      ];
                    };
                    "home" = {
                      mountpoint = "/home";
                      mountOptions = [
                        "compress=zstd"
                        "relatime"
                        "noexec"
                        "nosuid"
                      ];
                    };
                    "nix" = {
                      mountpoint = "/nix";
                      mountOptions = [
                        "compress=zstd"
                        "relatime"
                      ];
                    };
                    "swap" = {
                      mountpoint = "/swap";
                      swap = {
                        swapfile.size = "32G";
                        swapfile.path = "/swapfile";
                      };
                    };
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
