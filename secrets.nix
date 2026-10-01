let
  agekey = "age1nru4k2005d8820gxn03cfhlqcs5xfq0ycqjwtzsnzmkd2en5jc8q6dtsfq";
  framework-ssh = "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBOenmLNVJTnSO3yHG3o49ENb0XPqrJD0gCixHHDp4HQvbl4K3SFBQxGk5XL4plk0fiGpdmcz9qm17GBd0crv5bg=";
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
