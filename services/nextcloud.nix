{
  pkgs,
  config,
  lib,
  ...
}:
{

  # use caddy as webserver
  # imports = [
  # "${fetchTarball {
  #   url = "https://github.com/onny/nixos-nextcloud-testumgebung/archive/fa6f062830b4bc3cedb9694c1dbf01d5fdf775ac.tar.gz";
  #   sha256 = "0gzd0276b8da3ykapgqks2zhsqdv4jjvbv97dsxg0hgrhb74z0fs";}}/nextcloud-extras.nix"
  # ];

  services.nginx.virtualHosts."${config.services.nextcloud.hostName}".listen = [
    {
      addr = "127.0.0.1";
      port = 8080;
    }
  ];

  users.users.nextcloud = {
    isSystemUser = true;
    extraGroups = [
      "nextcloud"
    ];
  };
  age.secrets.nextcloud-pwd = {
    file = ../secrets/nextcloud-pwd.age;
    path = "/etc/nextcloud-pwd";
    owner = "nextcloud";
    group = "nextcloud";
  };
  services.nextcloud = {
    enable = true;
    configureRedis = true;
    # webserver = "caddy";
    package = pkgs.nextcloud35;
    # hostName = "localhost";
    hostName = "${config.networking.hostName}.dory-gondola.ts.net";
    https = true;
    config = {
      dbtype = "mysql";
      adminuser = "nextcloud";
      adminpassFile = "${config.age.secrets.nextcloud-pwd.path}";
    };
    database.createLocally = true;
    settings =
      let
        prot = "http";
        host = "localhost";
        dir = "/nextcloud";
      in
      {
        # Some sane defaults required to satisfy Nextcloud configuration check
        maintenance_window_start = 1;
        default_phone_region = "US";
        log_type = "systemd";
        serverid = 0;
        overwriteprotocol = prot;
        overwritehost = host;
        overwritewebroot = dir;
        overwrite.cli.url = "${prot}://${host}${dir}/";
        htaccess.RewriteBase = dir;
        trusted_domains = [
          "127.0.0.1"
          "galith"
        ];
        trusted_proxies = [
          "127.0.0.1"
          "galith"
        ];
      };
      # notify_push = {
      #   enable = true;
      #   nextcloudUrl = "http${lib.optionalString config.services.nextcloud.https "s"}://${config.services.nextcloud.hostName}${config.services.nextcloud.settings.overwritewebroot}";
      # };
    appstoreEnable = true;
    # extraAppsEnable = true;
    # extraApps = {
    #   inherit (config.services.nextcloud.package.packages.apps) contacts calendar tasks;
    #   e2ee = pkgs.fetchNextcloudApp (
    #     let
    #       version = "2.6.0";
    #     in
    #     {
    #       url = "https://github.com/nextcloud-releases/end_to_end_encryption/releases/download/v${version}/end_to_end_encryption-v${version}.tar.gz";
    #       hash = "sha256-KhnWOHWc83763LJEMVCJxDm6IYOomLqQam4v3VSm+X0=";
    #       license = "agpl3Only";
    #     }
    #   );
    # };
  };
  # systemd.services.nextcloud-custom-config = {
  #   path = [
  #     config.services.nextcloud.occ
  #   ];
  #   script = ''
  #     nextcloud-occ user:add nextadmin
  #     nextcloud-occ group:adduser admin nextadmin
  #   '';
  #   after = [ "nextcloud-setup.service" ];
  #   wantedBy = [ "multi-user.target" ];
  # };
}
