
{ pkgs, ... }:
{
  services.nextdns = {
    enable = true;
    arguments = [
      "-profile"
      "Profile ID here"
    ];
  };
  # systemd-resolved
  networking.nameservers = [
    "::1"
    "127.0.0.1"
  ];
}
