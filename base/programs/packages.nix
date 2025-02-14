{ pkgs, inputs, ... }:
let
  menu = inputs.menu.legacyPackages.${pkgs.system};
in
{
  imports = [
    ./radicle
  ];
  environment.systemPackages = with pkgs; [
    age
    alejandra
    atuin
    bat
    bat-extras.batman
    btop
    btrfs-progs
    busybox
    curl
    deadnix
    exfatprogs
    eza
    fastfetch
    fish
    fractal
    fzf
    gcc
    gettext
    git
    git-repo
    glas
    gleam
    glib
    glow
    gnumake
    gum
    home-manager
    hyfetch
    inputs.agenix.packages.x86_64-linux.default
    inputs.neovim.packages.x86_64-linux.default
    iosevka
    just
    lazygit
    libvirt
    lsof
    magic-wormhole-rs
    mcron
    menu.fuiska
    menu.rbld
    menu.unify
    miracode
    monocraft
    mpv
    nh
    nixd
    perl
    python3
    qemu
    qemu_kvm
    redis
    ripgrep
    rsync
    sbctl
    statix
    tealdeer
    topgrade
    tuba
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
    ungoogled-chromium
    virt-manager
    virt-viewer
    wormhole-william
  ];
}
