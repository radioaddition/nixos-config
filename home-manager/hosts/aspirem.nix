{ pkgs, config, libs, inputs, ... }:

{
  
  # in case of git.sr.ht outage
  #manual.html.enable = false;
  #manual.manpages.enable = false;
  #manual.json.enable = false;


  imports = [
  ];
  news.display = "silent";
  home.username = "radioaddition";
  home.homeDirectory = "/home/radioaddition";
  nixpkgs.config.allowUnfree = true;
  home.sessionPath = [ "$HOME/.local/bin" "/usr/local/bin" ];
  home.sessionVariables = {
    EDITOR = "nvim";
  };
  # GPG
  services.gpg-agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-gnome3;
  };

  # ZSH
  programs.zsh = {
    enable = true;
    shellAliases = {
      clearls = "clear && ls -A";
      ls = "ls -A";
      archive = "tar -czvf archive.tar.gz ";
      extract = "tar -xzvf ";
      update = "nix flake update";
      upgrade = "sudo nixos-rebuild switch --flake ./#aspirem --upgrade";
      apply = "sudo nixos-rebuild switch --flake ./#aspirem";
      apply-home = "home-manager switch --flake ./#aspirem && source ~/.zshrc";
      vivi = "nvim /home/radioaddition/.config/nvim/init.vim";
      clean = "nix-env --delete-generations old && nix-collect-garbage -d";
      cleanr = "sudo nix-env --delete-generations old && sudo nix-collect-garbage -d";
      commit = "git commit -a";
      push = "git push origin main";
      pushl = "git push local main";
    };
    zplug = {
      enable = true;
      plugins = [
        { name = "zsh-users/zsh-autosuggestions"; }
        { name = "zsh-users/zsh-syntax-highlighting"; }
        { name = "jeffreytse/zsh-vi-mode"; }
        { name = "romkatv/powerlevel10k"; tags = [ as:theme depth:1 ]; }
      ];
    };
    initExtraFirst = ''
      # Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
      # Initialization code that may require console input (password prompts, [y/n]
      # confirmations, etc.) must go above this block; everything else may go below.
      if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
        source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
      fi
      clear
      hyfetch
    '';
    initExtra = ''
. "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"

. ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      source $HOME/NixOS-Config/home-manager/.p10k.zsh
'';
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.package = pkgs.nix;
  home.packages = with pkgs; [
    github-desktop
    git-repo
    redis
    gnome.seahorse
    gnome.polari
    gpu-screen-recorder
    gpu-screen-recorder-gtk
    nodePackages_latest.pnpm
    pnpm-shell-completion
    goofcord
    pinentry-gnome3
    simplex-chat-desktop
    zed-editor
    monophony
    impression
    collision
    kleopatra
    mpv
    gradience
    yubikey-touch-detector
    fragments
    bottles
    boxbuddy
    nodejs-slim
    gleam
    glas
    bat
    wl-clipboard-rs
    neovim-gtk
    home-manager
    vscodium
    gettext
    glib
    gcc
    gnumake
    python3
    librewolf
    picard
    lutris
    gnome.gnome-tweaks
    mindustry-wayland
    shattered-pixel-dungeon
    keepassxc
    ventoy-full
    onionshare-gui
    tor-browser
    fragments
    helvum
    pavucontrol
    cinny-desktop

    # GNOME extensions
    gnomeExtensions.caffeine
    gnomeExtensions.dash2dock-lite
    gnomeExtensions.user-themes
    gnomeExtensions.alphabetical-app-grid
    gnomeExtensions.appindicator
    gnomeExtensions.quick-settings-audio-devices-renamer
    gnomeExtensions.gsconnect
    gnomeExtensions.search-light
    gnomeExtensions.zen
    gnomeExtensions.xwayland-indicator
    gnomeExtensions.workspace-isolated-dash
    gnomeExtensions.window-title-is-back
    gnomeExtensions.window-on-top
    gnomeExtensions.wiggle
    gnomeExtensions.wifi-qrcode
    gnomeExtensions.logo-menu
    gnomeExtensions.pano
    gnomeExtensions.proton-vpn-button

  ];
  home.enableNixpkgsReleaseCheck = false;
  home.stateVersion = "24.05";
}
