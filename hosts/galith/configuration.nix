# Edit this configuration file to define what should be installed on
# you system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  inputs,
  ...
}:
{
  hardware.enableAllFirmware = true;

  # Use a shorter password on this machine as it's only a testing device and also the keyboard is missing a key
  users.users."radioaddition".hashedPassword = "$y$j9T$qpNjkBLeZ1LLG5.N7VGyF1$0MJ4Rq9U.iBlFOHKu37YzNEErsW1F8WKrmhdK.Hrt2.";

  networking.hostName = "galith"; # Define your hostname.

  security.acme.acceptTerms = true;
  system.stateVersion = "26.05";
}
