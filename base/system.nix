{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
{

  age.identityPaths = [
    "/home/radioaddition/.ssh/key.age"
    "/home/radioaddition/.ssh/id_ed25519"
  ];
  imports = [
    ./aliases.nix
    inputs.agenix.nixosModules.default
  ];

  # Auto Updates
  system.autoUpgrade = {
    enable = true;
    flake = inputs.self.outPath;
    flags = [
      "--update-input"
      "nixpkgs"
      "--no-write-lock-file"
      "-L" # print build logs
    ];
    dates = "02:00";
    randomizedDelaySec = "45min";
  };

  # Nix Helper cli
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep 3";
    flake = "/home/radioaddition/nixos-config/";
  };

  # make external scripts and binaries work
  services.envfs.enable = true;
  programs.nix-ld.enable = true;

  # Swapfile oneshot service
  systemd.services = {
    create-swapfile = {
      serviceConfig.Type = "oneshot";
      wantedBy = [ "swap-swapfile.swap" ];
      # Replace first line in script with below when uutils builds successfully
      #${pkgs.uutils-coreutils}/bin/truncate -s 0 /swap/swapfile
      script = ''
        ${pkgs.coreutils}/bin/truncate -s 0 /swap/swapfile
        ${pkgs.e2fsprogs}/bin/chattr +C /swap/swapfile
        ${pkgs.btrfs-progs}/bin/btrfs property set /swap/swapfile compression none
      '';
    };
  };

  # System-wide environment variables
  environment.sessionVariables = {
    EDITOR = "nvim";
    DBX_CONTAINER_MANAGER = "podman";
    MANPAGER = "nvim +Man!";
  };

  # Base system packages not included
  environment.systemPackages = with pkgs; [
    (pkgs.uutils-coreutils.override { prefix = ""; })
    (pkgs.writeScriptBin "sudo" ''exec run0 "$@"'')
    exfat
    exfatprogs
    git
    neovim
  ];

  # command-not-found flake compatability
  environment.etc."programs.sqlite".source =
    inputs.programsdb.packages.${pkgs.system}.programs-sqlite;
  programs.command-not-found.dbPath = "/etc/programs.sqlite";

  # Bootloader
  boot = {
    # Boot animation
    plymouth = {
      enable = true;
      #theme = "nixos-bgrt";
      theme = "cuts_alt";
      themePackages = with pkgs; [
        adi1090x-plymouth-themes
        nixos-bgrt-plymouth
      ];
    };

    # Enable silent boot
    consoleLogLevel = 0;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "loglevel=3"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
    ];

    # Misc bootloader config
    loader = {
      timeout = 0;
      systemd-boot.enable = if config.boot.lanzaboote.enable then false else true;
      efi.canTouchEfiVariables = true;
    };
    extraModprobeConfig = ''
      options snd-intel-dspcfg dsp_driver=1
    '';

    # This is required for tpm2 unlock to function
    initrd.systemd.enable = true;

    # Pin kernel version
    kernelPackages = pkgs.linuxPackagesFor (
      pkgs.linuxKernel.kernels.linux_6_16.override {
        argsOverride = rec {
          src = pkgs.fetchurl {
            url = "mirror://kernel/linux/kernel/v${lib.versions.major version}.x/linux-${version}.tar.xz";
            sha256 = "sha256-Gkvi/mtSRqpKyJh6ikrzTEKo3X0ItGq0hRa8wb77zYM=";
          };
          version = "6.16";
          modDirVersion = "6.16.0";
        };
      }
    );
  };

  hardware.enableAllFirmware = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable virtualisation
  virtualisation = {
    kvmgt.enable = true;
    libvirtd.enable = true;
    waydroid.enable = true;
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber.enable = true;
  };

  # Enable flake support
  nix = {
    settings = {
      auto-optimise-store = true;
      warn-dirty = false;
    };
    extraOptions = ''
      experimental-features = nix-command flakes
    '';

    # Temporarily enable lix this way until builds succeed
    package = pkgs.lix;
  };

  # Enable ADB/Fastboot
  programs.adb.enable = true;

  # Replace coreutils with uutils-coreutils

  security.acme.acceptTerms = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
