{ lib, pkgs, config, inputs, ... }: {
  # First a greeter, since hyprland doesn't come with one
  services.greetd = {
    enable = true;
    package = pkgs.nwg-hello;
    #settings.default_session.command = ''
    #  ${ lib.makeBinPath [ pkgs.nwg-hello ] }/nwg-hello
    #'';
  };
  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };
  imports = [
    ./hyprgui.nix
  ];
  environment.systemPackages = with pkgs; [
    gnome-icon-theme
    hyprcursor
    hyprdim
    hypridle
    hyprland-protocols
    hyprlauncher
    hyprlock
    hyprnome
    hyprnotify
    hyprpaper
    hyprpicker
    hyprpolkitagent
    hyprshot
    hyprwall
    inputs.iwmenu.packages.${pkgs.system}.default
    kitty
    waybar
    wofi
  ];
}
