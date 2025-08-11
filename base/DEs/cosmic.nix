{ pkgs, ... }:
{
  services.xserver.enable = true;

  ### Enable the COSMIC Desktop Environment with GDM because cosmic greeter kinda sucks right now
  services = {
    displayManager.gdm.enable = true;
    desktopManager.cosmic = {
      enable = true;
    };
  };

  # Force apps to use native wayland
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  environment.cosmic.excludePackages = with pkgs; [
  ];

  # Enable GNOME keyring as cosmic doesn't have one yet
  services.gnome.gnome-keyring.enable = true;

  ### Configure keymap in X11
  services.xserver = {
    xkb = {
      layout = "us";
      variant = "";
    };
  };

  # Set a DE-dependent variable for gaming mode
  specialisation.gaming-mode.configuration.jovian.steam.desktopSession = "cosmic";
}
