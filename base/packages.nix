{ config, pkgs, inputs, lib, ... }: {

  environment.systemPackages = with pkgs; [
    atuin
    bat
    bat-extras.batman
    btop
    btrfs-progs
    busybox
    curl
    exfatprogs
    eza
    fastfetch
    gcc
    gettext
    git-repo
    glas
    gleam
    glib
    gnumake
    home-manager
    hyfetch
    iosevka
    just
    libvirt
    lsof
    magic-wormhole
    mcron
    miracode
    monocraft
    mpv
    perl
    python3
    qemu
    qemu_kvm
    redis
    ripgrep
    rsync
    sbctl
    topgrade
    usbtop
    wget
    wl-clipboard
    wlrctl
    yazi
    zoxide
  ];

  users.users.radioaddition.packages = with pkgs; [

    # Packages
    adwsteamgtk
    bottles
    boxbuddy
    brave
    cartridges
    chezmoi
    collision
    dconf-editor
    direnv
    discover-overlay
    distrobox
    fragments
    gnome-boxes
    gnome-extension-manager
    gnome-tweaks
    goofcord
    gparted
    guake
    helvum
    impression
    jamesdsp
    llama-cpp
    localsend
    lutris
    mindustry-wayland
    onionshare-gui
    pavucontrol
    picard
    pika-backup
    polari
    protonmail-bridge
    protonmail-bridge-gui
    protonplus
    protonvpn-gui
    ptyxis
    seahorse
    shattered-pixel-dungeon
    simplex-chat-desktop
    tor-browser
    wormhole-william
  ];

  # Ollama
  disabledModules = 
  [
    "services/misc/ollama.nix"
    "services/web-apps/nextjs-ollama-llm-ui.nix"
  ];
  imports = 
  [
    "${inputs.unstable}/nixos/modules/services/misc/ollama.nix"
    "${inputs.unstable}/nixos/modules/services/web-apps/nextjs-ollama-llm-ui.nix"
  ];

}

