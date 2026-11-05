let
  radioaddition_framework = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL0idNvgGiucWgup/mP78zyC23uFjYq0evcWdjGQUaBH";
  radioaddition_galith = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILI6jSq53F/3hEmSs+oq9L4TwOo1PrDMAgcA1uo1CCV/";
  users = [
    radioaddition_framework
    radioaddition_galith
  ];

  framework = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINIE/M4lr+BmwMqKyVsdDsD51lniDkeGirw9Ep7aitVY";
  galith = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAxLb09cbqqfktnEWOQrc/31Rm2x8jdCnD6/WjSpkTU1";
  systems = [
    framework
    galith
  ];
in
{
  "nextcloud-pwd.age" = {
    publicKeys = users ++ systems;
    armor = true;
  };
}
