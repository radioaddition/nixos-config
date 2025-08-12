{ pkgs, lib, ... }:
{
  services.xserver.enable = true;

  ### Enable the GNOME Desktop Environment.
  services = {
    displayManager.gdm.enable = true;
    desktopManager.gnome = {
      enable = true;
      extraGSettingsOverridePackages = [ pkgs.mutter ];
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

  # Set DE-dependent variables for gaming mode
  specialisation.gaming-mode.configuration = {
    jovian.steam.desktopSession = "gnome";
    services.displayManager.gdm.enable = lib.mkForce false;
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
      pop-shell
      quick-settings-audio-devices-renamer
      reboottouefi
      reorder-workspaces
      search-light
      tailscale-qs
      wifi-qrcode
      wiggle
      window-title-is-back
      xwayland-indicator
      zen
    ])
    ++ (with pkgs; [ pop-launcher ]);
}
