{ lib, hjem, ... }:
{
  imports = [
    hjem.nixosModules.hjem
    (lib.mkAliasOptionModule [ "hj" ] [ "hjem" "users" "radioaddition" ])
  ];
}
