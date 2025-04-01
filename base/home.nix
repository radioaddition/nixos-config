{ pkgs, lib, ... }: {
  # in case of git.sr.ht outage
  # manual.html.enable = false;
  # manual.manpages.enable = false;
  # manual.json.enable = false;
  # imports = [ ];
  # news.display = "silent";

  # Commented out because this can occasionally be different (ie some of my hosts have multiple users, and some are on Fedora/RHEL based (which uses /var/home)) but I need to be reminded to set it per host
  # home.username = "radioaddition";
  # home.homeDirectory = "/home/radioaddition";

  # lorri
  services.lorri.enable = true;

  programs.git = {
    enable = true;
    package = pkgs.gitFull;
    userName = "RadioAddition";
    userEmail = "radioaddition@pm.me";
    extraConfig = {
      init.defaultBranch = "main";
      sendemail = {
        smtpserver = "127.0.0.1";
        smtpuser = "radioaddition@pm.me";
        smtpencryption = "tls";
        smtpserverport = "1025";
        smtpsslcertpath = "";
      };
    };
    aliases = {
      ac = "!git add -A && git commit -m \"$(curl --silent --fail https://whatthecommit.com/index.txt)\"";
    };
  };

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    warn-dirty = false;
  };
  nix.package = lib.mkForce pkgs.nixVersions.stable;

  programs.home-manager.enable = true;
  #home.enableNixpkgsReleaseCheck = false; # If using a package from the unstable branch uncomment this
}
