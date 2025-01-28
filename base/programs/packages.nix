{ config, pkgs, inputs, lib, ... }:
let
  menu = inputs.menu.legacyPackages.${pkgs.system};
in
{

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
    fractal
    menu.fuiska
    fzf
    gcc
    gettext
    git-repo
    glas
    gleam
    glib
    glow
    gnumake
    gum
    home-manager
    hyfetch
    iosevka
    just
    libvirt
    lsof
    magic-wormhole-rs
    mcron
    miracode
    monocraft
    mpv
    nixd
    perl
    python3
    qemu
    qemu_kvm
    menu.rbld
    redis
    ripgrep
    rsync
    sbctl
    topgrade
    menu.unify
    up
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
    cartridges
    chezmoi
    collision
    dconf-editor
    direnv
    discover-overlay
    distrobox
    fragments
    gnome-extension-manager
    gnome-tweaks
    goofcord
    gparted
    guake
    helvum
    impression
    jamesdsp
    llama-cpp
    lutris
    mindustry-wayland
    onionshare-gui
    pavucontrol
    picard
    pika-backup
    polari
    protonvpn-gui
    ptyxis
    seahorse
    shattered-pixel-dungeon
    tor-browser
    ungoogled-chromium
    virt-manager
    virt-viewer
    wormhole-william
  ];

  # Ollama
  disabledModules = 
  [
    "services/misc/ollama.nix"
    "services/web-apps/nextjs-ollama-llm-ui.nix"
  ];
  imports = [
    "${inputs.unstable}/nixos/modules/services/misc/ollama.nix"
    "${inputs.unstable}/nixos/modules/services/web-apps/nextjs-ollama-llm-ui.nix"
  ];
}

