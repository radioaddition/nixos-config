{ lib, config, pkgs, ... }: {
  age.secrets.radicle.file = ./radicle.age;
  services.radicle = {
    enable = true;
    httpd.enable = true;
    node.openFirewall = true;
    privateKeyFile = config.age.secrets.radicle.file;
    publicKey = ./radicle.pub;
  };
}
