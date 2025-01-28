{ lib, pkgs, config, inputs, ... }: {
  # First a greeter, since hyprland doesn't come with one
  services.greetd = {
    enable = true;
    package = pkgs.nwg-hello;
  };
  programs.hyprland = {
    enable = true;
  };
}
