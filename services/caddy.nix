{
  config,
  ...
}:
{
  services.caddy = {
    enable = true;
    # virtualHosts."${config.networking.hostName}.dory-gondala.ts.net:443".extraConfig = ''
    #   reverse_proxy /nextcloud/* localhost:8080
    # '';
    virtualHosts."${config.networking.hostName}.dory-gondala.ts.net".extraConfig = ''
      reverse_proxy /nextcloud/* https://localhost:8080 {
        transport http {
          tls_insecure_skip_verify
        }
      }
    '';
  };
}
