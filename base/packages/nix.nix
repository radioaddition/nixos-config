{ pkgs, inputs, ... }:
let
  menu = inputs.menu.legacyPackages.${pkgs.system};
  stable = inputs.stable.legacyPackages.${pkgs.system};
in
{
  imports = [
    ./radicle
  ];

  # System packages
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
    cyme
    deadnix
    exfatprogs
    eza
    fastfetch
    fish
    fragments
    fzf
    gcc
    gettext
    git
    git-repo
    gleam
    glib
    glow
    gnumake
    gum
    home-manager
    hyfetch
    inputs.agenix.packages.x86_64-linux.default
    inputs.neovim.packages.x86_64-linux.default
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
    rustup
    sbctl
    statix
    tealdeer
    tmux
    topgrade
    tuba
    up
    usbtop
    wget
    wl-clipboard
    yazi
    zoxide
  ];

  # User packages
  users.users.radioaddition.packages = with pkgs; [
    # Packages
    bottles
    boxbuddy
    cartridges
    chezmoi
    collision
    dconf-editor
    direnv
    discover-overlay
    distrobox
    equibop
    fractal
    gnome-extension-manager
    gnome-tweaks
    gparted
    helvum
    impression
    jamesdsp
    lumafly
    lutris
    mindustry-wayland
    onionshare-gui
    pavucontrol
    pika-backup
    protontricks
    protonvpn-gui
    seahorse
    shattered-pixel-dungeon
    ungoogled-chromium
    virt-manager
    virt-viewer
    wormhole-william
  ];

  # Fonts
  fonts.packages = with pkgs; [
    adwaita-fonts
    nerd-fonts.iosevka
    nerd-fonts.meslo-lg
  ];
}
