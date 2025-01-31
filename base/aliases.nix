{ lib, ... }:
{
  imports = [
    (lib.mkAliasOptionModule
      [ "hm" ]
      [
        "home-manager"
        "users"
        "radioaddition"
      ]
    )
    (lib.mkAliasOptionModule [ "hj" ] [ "hjem" "users" "radioaddition" ])
  ];
}
