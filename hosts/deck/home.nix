{ pkgs, config, ... }:
{
  # in case of git.sr.ht outage
  #manual.html.enable = false;
  #manual.manpages.enable = false;
  #manual.json.enable = false;

  imports = [ ];
  news.display = "silent";
  home.username = "deck";
  home.homeDirectory = "/home/deck";
  nixpkgs.config.allowUnfree = true;
  home.sessionPath = [
    "$HOME/.local/bin"
    "/usr/local/bin"
  ];
  home.sessionVariables = {
    EDITOR = "nvim";
    DBX_CONTAINER_MANAGER = "podman";
  };
  # GPG
  services.gpg-agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-gnome3;
  };

  # Syncthing
  services.syncthing = {
    enable = true;
    tray.enable = true;
  };

  # ZSH
  programs.zsh = {
    enable = true;
    zplug = {
      enable = true;
      plugins = [
        { name = "zsh-users/zsh-autosuggestions"; }
        { name = "zsh-users/zsh-syntax-highlighting"; }
        { name = "jeffreytse/zsh-vi-mode"; }
        {
          name = "romkatv/powerlevel10k";
          tags = [
            "as:theme"
            "depth:1"
          ];
        }
      ];
    };
    initExtraFirst = ''
      # Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
      # Initialization code that may require console input (password prompts, [y/n]
      # confirmations, etc.) must go above this block; everything else may go below.
      if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
        source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
      fi
    '';
    initExtra = ''
      . "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"

      . ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
            source "$HOME/NixOS-Config/.p10k.zsh"
            eval "$(atuin init zsh)"
    '';
  };

  nix.settings = {
    auto-optimise-store = true;
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };
  nix.package = pkgs.nixFlakes;
  home.packages = with pkgs; [
    # Packages

    adwsteamgtk
    atuin
    bat
    bottles
    boxbuddy
    btop
    cartridges
    curl
    direnv
    distrobox
    docker-compose
    eza
    freshfetch
    gcc
    gettext
    git
    git-repo
    glib
    gnome.dconf-editor
    gnome-extension-manager
    gnome.gnome-boxes
    gnome.gnome-tweaks
    gnumake
    goofcord
    home-manager
    hyfetch
    iosevka
    jamesdsp
    librewolf
    lumafly
    lutris
    meslo-lgs-nf
    mindustry-wayland
    monophony
    mpv
    neovim
    ollama
    onionshare-gui
    openrazer-daemon
    pavucontrol
    perl
    pika-backup
    pipx
    polychromatic
    protonplus
    protonvpn-gui
    python3
    redis
    r2modman
    sassc
    shattered-pixel-dungeon
    topgrade
    tuckr
    wget
    wl-clipboard
    wlrctl
    xmrig-mo
  ];
  #home.enableNixpkgsReleaseCheck = false; # If using a package from the unstable branch uncomment this
  home.stateVersion = "24.05";
}
