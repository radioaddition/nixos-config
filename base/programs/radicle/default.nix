{ lib, config, pkgs, ... }: {
  age.secrets.radicle.file = ./radicle.age;
  services.radicle = {
    enable = true;
    httpd.enable = true;
    node.openFirewall = true;
    privateKeyFile = config.age.secrets.radicle.file;
    publicKey = ./radicle.pub;
    settings = {
      publicExplorer = "https://app.radicle.xyz/nodes/$host/$rid$path";
      preferredSeeds = [
        "z6MkrLMMsiPWUcNPHcRajuMi9mDfYckSoJyPwwnknocNYPm7@seed.radicle.garden:8776"
        "z6Mkmqogy2qEM2ummccUthFEaaHvyYmYBYh3dbe9W4ebScxo@ash.radicle.garden:8776"
      ];
      web.pinned.repositories = [];
      cli.hints = true;
      node = {
        alias = "radioaddition";
        listen = [];
        peers.type = "dynamic";
        connect = [];
        externalAddresses = [];
        network = "main";
        log = "INFO";
        relay = "auto";
        limits = {
          routingMaxSize = 1000;
          routingMaxAge = 604800;
          gossipMaxAge = 1209600;
          fetchConcurrency = 1;
          maxOpenFiles = 4096;
          rate = {
	    inbound = {
              fillRate = 5.0;
              capacity = 102;
            };
            outbound = {
              fillRate = 10.0;
              capacity = 204;
            };
          };
          connection = {
            inbound = 128;
            outbound = 1;
          };
        };
        workers = 8;
        seedingPolicy = {
          default = "block";
        };
      };
    };
  };
}
