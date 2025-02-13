let
  agekey = "age1nru4k2005d8820gxn03cfhlqcs5xfq0ycqjwtzsnzmkd2en5jc8q6dtsfq";
  framework-ssh = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINIE/M4lr+BmwMqKyVsdDsD51lniDkeGirw9Ep7aitVY";
  all-keys = [ agekey framework-ssh ];
in
{
  "base/programs/radicle/radicle.age" = {
    publicKeys = all-keys;
    mode = "0550";
    owner = "radicle";
    group = "radicle";
  };
}
