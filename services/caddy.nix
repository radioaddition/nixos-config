{
  config,
  ... }:
{
  services.caddy = {
    enable = true;
    virtualHosts."${config.networking.hostname}.dory-gondala.ts.net:443".extraConfig = ''
      reverse_proxy /nextcloud/* localhost:8080
    '';
    # virtualHosts."${config.networking.hostname}.dory-gondala.ts.net:80".extraConfig = ''
    #   reverse_proxy /admin/nextcloud/* https://localhost:8080 {
    #     transport http {
    #       tls_insecure_skip_verify
    #     }
    #   }
    # '';
  };
}
