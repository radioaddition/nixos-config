{
  pkgs,
  config,
  ... }:
{

  # use caddy as webserver
  # imports = [
  # "${fetchTarball {
  #   url = "https://github.com/onny/nixos-nextcloud-testumgebung/archive/fa6f062830b4bc3cedb9694c1dbf01d5fdf775ac.tar.gz";
  #   sha256 = "0gzd0276b8da3ykapgqks2zhsqdv4jjvbv97dsxg0hgrhb74z0fs";}}/nextcloud-extras.nix"
  # ];

  services.nginx.virtualHosts."${config.services.nextcloud.hostName}".listen = [ {
    addr = "127.0.0.1";
    port = 8080; # NOT an exposed port
  } ];

  services.nextcloud = {
    enable = true;
    # webserver = "caddy";
    package = pkgs.nextcloud35;
    hostName = "${config.networking.hostName}.dory-gondala.ts.net";
    config.adminpassFile = config.age.secrets.nextcloud-pwd.path;
    config.dbtype = "mysql";
    database.createLocally = true;
    settings = let
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
      cage = pkgs.fetchNextcloudApp (
      let
        version = "0.2.1";
      in
      {
        url = "https://github.com/j-suchy/nextcloud-cage/releases/download/v${version}/cage-${version}.tar.gz";
        hash = "sha256-Xr1SRSmXo2r8yOGuoMyoXhD0oPVm/0/ISHlmNZpJYsg=";
        license = "agpl3Only";
      });
    };
  };
}
