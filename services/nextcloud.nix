{
  pkgs,
  config,
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
      port = 8080; # NOT an exposed port
    }
  ];

  services.nextcloud = {
    enable = true;
    # webserver = "caddy";
    package = pkgs.nextcloud35;
    hostName = "${config.networking.hostName}.dory-gondala.ts.net";
    config.dbtype = "mysql";
    config.adminpassFile = config.age.secrets.nextcloud-pwd.path;
    database.createLocally = true;
    settings =
      let
        prot = "https";
        host = "127.0.0.1";
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
      };
    notify_push.enable = true;
    appstoreEnable = true;
    extraAppsEnable = true;
    extraApps = {
      inherit (config.services.nextcloud.package.packages.apps) contacts calendar tasks;
      e2ee = pkgs.fetchNextcloudApp (
        let
          version = "2.6.0";
        in
        {
          url = "https://github.com/nextcloud/end_to_end_encryption/archive/refs/tags/v${version}.tar.gz";
          hash = "sha256-7VpJ1hR7uEV+APL/AMqGzLj4jm+xo48P4w2z65dg3KA=";
          license = "agpl3Only";
        }
      );
    };
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
