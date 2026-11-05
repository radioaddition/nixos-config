{ pkgs, config, ... }:
{
  #' Configure network proxy if necessary
  #- networking.proxy.default = "http://user:password@proxy:port/";
  #- networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # faster boot
  systemd.network.wait-online.enable = false; 
  boot.initrd.systemd.network.wait-online.enable = false;

  # CaptivePortal logins
  programs.captive-browser = {
    enable = true;

    # NetworkManager
    interface = "wlp1s0";
  };

  # NetworkManager
  networking.networkmanager = {
    enable = true;
    wifi.macAddress = "random";
  };

  # NTP
  services.ntp.enable = true;

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
    "1.1.1.1"
  ];
  services.resolved = {
    enable = true;
    settings.Resolve = {
      DNSSEC = "true";
      DNSOverTLS = "true";
      Domains = [ "~." ];
      #llmnr = "true";
      FallbackDns = (config.networking.nameservers ++ [ "1.1.1.1" ]);
    };
  };

  # KDE Connect
  programs.kdeconnect = {
    enable = true;
    # package = pkgs.valent;
  };

  # Configure the firewall.
  networking.nftables.enable = true;
  networking.firewall = {
    allowedTCPPorts = [
      25565 # minecraft
    ];
    allowedUDPPorts = [
      25565 # minecraft
      config.services.tailscale.port
    ];
    trustedInterfaces = [
      config.services.tailscale.interfaceName
      "virbr0"
    ];
  };
  #' Or disable the firewall altogether.
  #' networking.firewall.enable = false;

  time.timeZone = "America/New_York";
}
