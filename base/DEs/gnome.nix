{pkgs, ...}: {
  services.xserver.enable = true;

  ### Enable the GNOME Desktop Environment.
  services.xserver = {
    displayManager.gdm.enable = true;
    desktopManager.gnome = {
      enable = true;
      extraGSettingsOverridePackages = [pkgs.mutter];
      extraGSettingsOverrides = ''
        [org.gnome.mutter]
        experimental-features=['variable-refresh-rate', 'scale-monitor-framebuffer']
      '';
    };
  };

  # Force apps to use native wayland
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  environment.gnome.excludePackages = with pkgs; [
    yelp
    cheese
    simple-scan
    totem
    gnome-tour
    gnome-software
    gnome-weather
    epiphany
  ];

  ### Configure keymap in X11
  services.xserver = {
    xkb = {
      layout = "us";
      variant = "";
    };
  };

  # GNOME Extensions
  users.users.radioaddition.packages =
    (with pkgs.gnomeExtensions; [
      alphabetical-app-grid
      appindicator
      blur-my-shell
      caffeine
      dash-to-dock
      forge
      gsconnect
      logo-menu
      quick-settings-audio-devices-renamer
      reboottouefi
      reorder-workspaces
      search-light
      systemd-manager
      tailscale-qs
      #valent
      wifi-qrcode
      wiggle
      window-title-is-back
      xwayland-indicator
      zen
    ])
    ++ (with pkgs; [
      pop-launcher
    ]);
}
