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

  networking.hostName = "galith"; # Define your hostname.

  security.acme.acceptTerms = true;
  system.stateVersion = "26.05";
}
