let
  master = "age1ywe7vjgqzrsd863c0084vv2kxxgcn7e6ceuaywz9gzd85xwuu32qqpdat4";
  radioaddition_framework = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL0idNvgGiucWgup/mP78zyC23uFjYq0evcWdjGQUaBH";
  radioaddition_galith = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAxLb09cbqqfktnEWOQrc/31Rm2x8jdCnD6/WjSpkTU1 radioaddition@galith";
  users = [
    radioaddition_framework
    radioaddition_galith
  ];

  framework = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINIE/M4lr+BmwMqKyVsdDsD51lniDkeGirw9Ep7aitVY";
  galith = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDkW48gT4Cbeudh3tOlkzvkUDnCD1B9MCdz8rM1yHg2S root@galith";
  systems = [
    framework
    galith
  ];
in
{
  "nextcloud-pwd.age" = {
    publicKeys = users ++ systems ++ [ master ];
    armor = true;
  };
}
