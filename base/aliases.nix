{ lib, ... }:
{
  imports = [
    (lib.mkAliasOptionModule [ "hj" ] [ "hjem" "users" "radioaddition" ])
  ];
}
