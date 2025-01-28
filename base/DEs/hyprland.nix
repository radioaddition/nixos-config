{ lib, pkgs, config, inputs, ... }: {
  # First a greeter, since hyprland doesn't come with one
  services.greetd = {
    enable = true;
    package = pkgs.nwg-hello;
    settings.default_session.command = ''
      ${ lib.makeBinPath [ pkgs.greetd.gtkgreet ] }/gtkgreet -l -c Hyprland
    '';
  };
  programs.hyprland = {
    enable = true;
  };
}
