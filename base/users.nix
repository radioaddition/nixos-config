{...}: {
  users.mutableUsers = false;
  users.users.radioaddition = {
    isNormalUser = true;
    description = "RadioAddition";
    extraGroups = ["adbusers" "docker" "kvm" "libvirt" "libvirtd" "lxd" "networkmanager" "openrazer" "wheel" "tss"];
    hashedPassword = "$y$j9T$F4h7o3ioLWalvZUhYzE8b.$2RrSEm8FmoZi3tS4EWGo2g0S0INy/oenfXqWn9yJqJA";
  };
  # Create a separate wheel user
  #  users.users.radioadmin = { # This has to be disabled until I can get building with run0 to work properly
  #    isNormalUser = true;
  #    description = "RadioAdmin";
  #    extraGroups = [ "adbusers" "docker" "kvm" "libvirt" "libvirtd" "lxd" "networkmanager" "openrazer" "wheel" "nix" ];
  #    # Change this password on an actual system!!
  #    hashedPassword = "$y$j9T$gMRIRcus7uO1X6zrPTfVn/$0iOFINi8HZPH5b0QpXXCQbanUwYe9lpzjD17NbitD39";
  #  };
  services.vsftpd.localUsers = true;
}
