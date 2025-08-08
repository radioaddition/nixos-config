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
    inputs.zen-browser.packages."${system}".default
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
    fragments
    gnome-extension-manager
    gnome-tweaks
    gparted
    guake
    helvum
    impression
    jamesdsp
    lumafly
    lutris
    mindustry-wayland
    onionshare-gui
    pavucontrol
    picard
    pika-backup
    polari
    protontricks
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
