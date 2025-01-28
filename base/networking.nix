{pkgs, ...}: {
  #' Configure network proxy if necessary
  #- networking.proxy.default = "http://user:password@proxy:port/";
  #- networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # NetworkManager
  networking.networkmanager.enable = false;

  environment.systemPackages = with pkgs; [
    impala # a tui for iwd
  ];

  # CaptivePortal logins
  programs.captive-browser = {
    enable = true;
    interface = "wlan0";
  };

  # iwd
  networking.wireless.iwd = {
    enable = true;
    settings = {
      General = {
        EnableNetworkConfiguration = true;
        AddressRandomization = "network";
        AddressRandomizationRange = "full";
        ManagementFrameProtection = "1";
      };
      Network = {
        NameResolvingService = "systemd";
      };
      #Scan = {
      #  DisablePeriodicScan = true;
      #  DisableRoamingScan = true;
      #};
    };
  };

  # systemd-networkd
  boot.initrd.systemd.network.enable = true;
  services.networkd-dispatcher.enable = true;
  networking.useNetworkd = true;
  systemd.network.enable = true;

  # systemd-resolved
  networking.nameservers = [
    "2a07:e340::3"
    "2a07:e340::2"
    "194.242.2.3"
    "194.242.2.2"
    "1.1.1.1"
    "1.0.0.1"
  ];
  services.resolved = {
    enable = true;
    dnssec = "true";
    dnsovertls = "true";
    domains = ["~."];
    #llmnr = "true";
    fallbackDns = [
      "2a07:e340::3"
      "2a07:e340::2"
      "194.242.2.3"
      "194.242.2.2"
      "1.1.1.1"
      "1.0.0.1"
    ];
  };

  # Tailscale
  services.tailscale = {
    enable = true;
  };

  # Open ports in the firewall.
  networking.firewall = {
    allowedTCPPorts = [
      65530
      51413
      9052
      9053
      9080
      53317
    ];
    allowedUDPPorts = [
      65530
      51413
      9052
      9053
      9080
      53317
    ];
    allowedTCPPortRanges = [
      {
        from = 1714;
        to = 1764;
      } # KDE Connect
    ];
    allowedUDPPortRanges = [
      {
        from = 1714;
        to = 1764;
      } # KDE Connect
    ];
    trustedInterfaces = [
      "tailscale0"
    ];
  };
  #' Or disable the firewall altogether.
  #' networking.firewall.enable = false;

  time.timeZone = "America/New_York";
}
