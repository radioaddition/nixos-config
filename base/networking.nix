{ pkgs, config, ... }:
{
  #' Configure network proxy if necessary
  #- networking.proxy.default = "http://user:password@proxy:port/";
  #- networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # environment.systemPackages = with pkgs; [
  #   impala # a tui for iwd
  # ];

  # CaptivePortal logins
  programs.captive-browser = {
    enable = true;
    interface = "wlan0";
  };

  # NetworkManager
  networking.networkmanager = {
    enable = true;
    wifi = {
      # backend = "iwd";
      macAddress = "random";
    };
  };

  # iwd
  # networking.wireless.iwd = {
  #   enable = true;
  #   settings = {
  #     General = {
  #       EnableNetworkConfiguration = true;
  #       # AddressRandomization = "network";
  #       # AddressRandomizationRange = "full";
  #       ManagementFrameProtection = "1";
  #     };
  #     Network = {
  #       NameResolvingService = "systemd";
  #     };
  #     #Scan = {
  #     #  DisablePeriodicScan = true;
  #     #  DisableRoamingScan = true;
  #     #};
  #   };
  # };

  # systemd-networkd
  boot.initrd.systemd.network.enable = true;
  services.networkd-dispatcher.enable = true;
  networking.useNetworkd = true;
  systemd.network.enable = true;

  # systemd-resolved
  networking.nameservers = [
    "2a07:a8c0::#cf76b1.dns.nextdns.io"
    "45.90.28.0#cf76b1.dns.nextdns.io"
    "2a07:a8c1::#cf76b1.dns.nextdns.io"
    "45.90.30.0#cf76b1.dns.nextdns.io"
    "194.242.2.4"
  ];
  services.resolved = {
    enable = true;
    dnssec = "true";
    dnsovertls = "true";
    domains = [ "~." ];
    #llmnr = "true";
    fallbackDns = (config.networking.nameservers ++ [ "1.1.1.1" ]);
  };

  # KDE Connect
  programs.kdeconnect = {
    enable = true;
    package = pkgs.valent;
  };

  # Tailscale
  services.tailscale = {
    enable = true;
  };

  # Open ports in the firewall.
  networking.firewall = {
    allowedTCPPorts = [
      25565 # minecraft
    ];
    allowedUDPPorts = [
      25565 # minecraft
    ];
    trustedInterfaces = [
      "tailscale0"
      "virbr0"
    ];
  };
  #' Or disable the firewall altogether.
  #' networking.firewall.enable = false;

  time.timeZone = "America/New_York";
}
