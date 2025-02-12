{
  config,
  pkgs,
  inputs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    btrfs-progs
    fish
    git
    neovim
  ];

  environment.sessionVariables = {
    EDITOR = "nvim";
    DBX_CONTAINER_MANAGER = "podman";
  };

  # Define system hostname
  networking.hostName = "installer";

  # Enable networking
  networking.networkmanager.enable = true;

  # Swapfile oneshot service
  systemd.services = {
    create-swapfile = {
      serviceConfig.Type = "oneshot";
      wantedBy = [ "swap-swapfile.swap" ];
      script = ''
        ${pkgs.coreutils}/bin/truncate -s 0 /swap/swapfile
        ${pkgs.e2fsprogs}/bin/chattr +C /swap/swapfile
        ${pkgs.btrfs-progs}/bin/btrfs property set /swap/swapfile compression none
      '';
    };
  };

  # Bootloader
  boot = {
    # Misc bootloader config
    loader.efi.canTouchEfiVariables = true;
    extraModprobeConfig = ''
      options snd-intel-dspcfg dsp_driver=1
    '';

    loader.systemd-boot.enable = true;
  };

  # command-not-found flake compatability
  environment.etc."programs.sqlite".source =
    inputs.programsdb.packages.${pkgs.system}.programs-sqlite;
  programs.command-not-found.dbPath = "/etc/programs.sqlite";

  hardware.enableAllFirmware = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

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

  # Enable flake support
  nix = {
    settings = {
      auto-optimise-store = true;
      warn-dirty = false;
    };
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  time.timeZone = "America/New_York";

  security.acme.acceptTerms = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
  hm.home.stateVersion = "24.11"; # Did you read the comment?
}
