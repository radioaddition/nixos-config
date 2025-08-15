{ config, inputs, ... }:
{
  imports = [ inputs.nix-flatpak.nixosModules.nix-flatpak ];
  services.flatpak = {
    enable = true;
    uninstallUnmanaged = true;
    update.auto = {
      enable = true;
      onCalendar = "daily";
    };
    remotes = [
      {
        name = "flathub";
        location = "https://flathub.org/repo/flathub.flatpakrepo";
      }
    ];
    packages = [
      # Sober, for roblox
      {
        appId = "org.vinegarhq.Sober";
        origin = "flathub";
      }
      # torrhunt
      {
        appId = "com.ktechpit.torrhunt";
        origin = "flathub";
      }
      # dino
      {
        appId = "im.dino.Dino";
        origin = "flathub";
      }
      #protonmail-bridge
      {
        appId = "ch.protonmail.protonmail-bridge";
        origin = "flathub";
      }
      # GoodCord
      "io.github.milkshiift.GoofCord"
      # Warp, a wormhole client
      {
        appId = "app.drey.Warp";
        origin = "flathub";
      }
      # Fotema, a photo viewer
      {
        appId = "app.fotema.Fotema";
        origin = "flathub";
      }
      # SimpleX Chat
      {
        appId = "chat.simplex.simplex";
        origin = "flathub";
      }
      {
        appId = "org.torproject.torbrowser-launcher";
        origin = "flathub";
      }
      # GPU Screen recorder
      {
        appId = "com.dec05eba.gpu_screen_recorder";
        origin = "flathub";
      }
      # Pods, a podman manager
      {
        appId = "com.github.marhkb.Pods";
        origin = "flathub";
      }
      # Flatseal, a flatpak permissions manager
      {
        appId = "com.github.tchx84.Flatseal";
        origin = "flathub";
      }
      # EasyEffects
      {
        appId = "com.github.wwmm.easyeffects";
        origin = "flathub";
      }
      # Bottles, a wine prefix manager
      {
        appId = "com.usebottles.bottles";
        origin = "flathub";
      }
      # KTorrent
      {
        appId = "org.kde.ktorrent";
        origin = "flathub";
      }
      # Snoop, search through file contents (rather than just names)
      {
        appId = "de.philippun1.Snoop";
        origin = "flathub";
      }
      # Metadata cleaner
      {
        appId = "fr.romainvigier.MetadataCleaner";
        origin = "flathub";
      }
      # Ente Auth, 2FA app
      {
        appId = "io.ente.auth";
        origin = "flathub";
      }
      # Ignition, startup process manager
      {
        appId = "io.github.flattool.Ignition";
        origin = "flathub";
      }
      # Warehouse, flatpak manager
      {
        appId = "io.github.flattool.Warehouse";
        origin = "flathub";
      }
      # Flatsweep, flatpak remnant cleaner
      {
        appId = "io.github.giantpinkrobots.flatsweep";
        origin = "flathub";
      }
      # Video wallpaper
      {
        appId = "io.github.jeffshee.Hidamari";
        origin = "flathub";
      }
      # Discord client
      {
        appId = "io.github.milkshiift.GoofCord";
        origin = "flathub";
      }
      # LLM app
      {
        appId = "io.github.qwersyk.Newelle";
        origin = "flathub";
      }
      # GDM Settings
      {
        appId = "io.github.realmazharhussain.GdmSettings";
        origin = "flathub";
      }
      # WiVRn, SteamVR alternative
      {
        appId = "io.github.wivrn.wivrn";
        origin = "flathub";
      }
      # Minecraft Bedrock Launcher
      {
        appId = "io.mrarm.mcpelauncher";
        origin = "flathub";
      }
      # Fedora Media Writer
      {
        appId = "org.fedoraproject.MediaWriter";
        origin = "flathub";
      }
      # GNOME Calculator
      {
        appId = "org.gnome.Calculator";
        origin = "flathub";
      }
      # GNOME Calendar
      {
        appId = "org.gnome.Calendar";
        origin = "flathub";
      }
      # GNOME Connection manager
      {
        appId = "org.gnome.Connections";
        origin = "flathub";
      }
      # GNOME Contacts
      {
        appId = "org.gnome.Contacts";
        origin = "flathub";
      }
      # Document viewer
      {
        appId = "org.gnome.Evince";
        origin = "flathub";
      }
      # GNOME Logs
      {
        appId = "org.gnome.Logs";
        origin = "flathub";
      }
      # Image Viewer
      {
        appId = "org.gnome.Loupe";
        origin = "flathub";
      }
      # GNOME Screenshot
      {
        appId = "org.gnome.Snapshot";
        origin = "flathub";
      }
      # GNOME Text Editor
      {
        appId = "org.gnome.TextEditor";
        origin = "flathub";
      }
      # Gnome Keepass client
      {
        appId = "org.gnome.World.Secrets";
        origin = "flathub";
      }
      # Disk usage analyzer
      {
        appId = "org.gnome.baobab";
        origin = "flathub";
      }
      # GNOME Clock
      {
        appId = "org.gnome.clocks";
        origin = "flathub";
      }
      # GNOME Font Viewer
      {
        appId = "org.gnome.font-viewer";
        origin = "flathub";
      }
      # Markdown text editor
      {
        appId = "org.gnome.gitlab.somas.Apostrophe";
        origin = "flathub";
      }
      # KeePassXC
      {
        appId = "org.keepassxc.KeePassXC";
        origin = "flathub";
      }
      # LocalSend
      {
        appId = "org.localsend.localsend_app";
        origin = "flathub";
      }
      # Parabolic
      {
        appId = "org.nickvision.tubeconverter";
        origin = "flathub";
      }
      # PrismLauncher, minecraft launcher
      {
        appId = "org.prismlauncher.PrismLauncher";
        origin = "flathub";
      }
      # Signal
      {
        appId = "org.signal.Signal";
        origin = "flathub";
      }
      # Menu item editor
      {
        appId = "page.codeberg.libre_menu_editor.LibreMenuEditor";
        origin = "flathub";
      }
    ];
  };
  # Flatpak requires this functionality
  security.unprivilegedUsernsClone = config.services.flatpak.enable;
}
