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
      # Bottles, a wine prefix manager
      { appId = "com.usebottles.bottles"; origin = "flathub"; }
      # Dino
      { appId = "im.dino.Dino"; origin = "flathub"; }
      # Discord client
      { appId = "io.github.milkshiift.GoofCord"; origin = "flathub"; }
      # Disk usage analyzer
      { appId = "org.gnome.baobab"; origin = "flathub"; }
      # Document viewer
      { appId = "org.gnome.Evince"; origin = "flathub"; }
      # EasyEffects
      { appId = "com.github.wwmm.easyeffects"; origin = "flathub"; }
      # Ente Auth, 2FA app
      { appId = "io.ente.auth"; origin = "flathub"; }
      # Fedora Media Writer
      { appId = "org.fedoraproject.MediaWriter"; origin = "flathub"; }
      # Fightcade
      { appId = "com.fightcade.Fightcade"; origin = "flathub"; }
      # Flatseal, a flatpak permissions manager
      { appId = "com.github.tchx84.Flatseal"; origin = "flathub"; }
      # Flatsweep, flatpak remnant cleaner
      { appId = "io.github.giantpinkrobots.flatsweep"; origin = "flathub"; }
      # Fotema, a photo viewer
      { appId = "app.fotema.Fotema"; origin = "flathub"; }
      # GDM Settings
      { appId = "io.github.realmazharhussain.GdmSettings"; origin = "flathub"; }
      # GNOME Calculator
      { appId = "org.gnome.Calculator"; origin = "flathub"; }
      # GNOME Calendar
      { appId = "org.gnome.Calendar"; origin = "flathub"; }
      # GNOME Clock
      { appId = "org.gnome.clocks"; origin = "flathub"; }
      # GNOME Connection manager
      { appId = "org.gnome.Connections"; origin = "flathub"; }
      # GNOME Contacts
      { appId = "org.gnome.Contacts"; origin = "flathub"; }
      # GNOME Font Viewer
      { appId = "org.gnome.font-viewer"; origin = "flathub"; }
      # GNOME Logs
      { appId = "org.gnome.Logs"; origin = "flathub"; }
      # GNOME Screenshot
      { appId = "org.gnome.Snapshot"; origin = "flathub"; }
      # GNOME Text Editor
      { appId = "org.gnome.TextEditor"; origin = "flathub"; }
      # GPU Screen recorder
      { appId = "com.dec05eba.gpu_screen_recorder"; origin = "flathub"; }
      # Gnome Keepass client
      { appId = "org.gnome.World.Secrets"; origin = "flathub"; }
      # GoodCord
      { appId = "io.github.milkshiift.GoofCord"; origin = "flathub"; }
      # Ignition, startup process manager
      { appId = "io.github.flattool.Ignition"; origin = "flathub"; }
      # Image Viewer
      { appId = "org.gnome.Loupe"; origin = "flathub"; }
      # KTorrent
      { appId = "org.kde.ktorrent"; origin = "flathub"; }
      # KeePassXC
      { appId = "org.keepassxc.KeePassXC"; origin = "flathub"; }
      # LLM app
      { appId = "io.github.qwersyk.Newelle"; origin = "flathub"; }
      # LocalSend
      { appId = "org.localsend.localsend_app"; origin = "flathub"; }
      # Markdown text editor
      { appId = "org.gnome.gitlab.somas.Apostrophe"; origin = "flathub"; }
      # Menu item editor
      { appId = "page.codeberg.libre_menu_editor.LibreMenuEditor"; origin = "flathub"; }
      # Metadata cleaner
      { appId = "fr.romainvigier.MetadataCleaner"; origin = "flathub"; }
      # Minecraft Bedrock Launcher
      { appId = "io.mrarm.mcpelauncher"; origin = "flathub"; }
      # Parabolic
      { appId = "org.nickvision.tubeconverter"; origin = "flathub"; }
      # Pods, a podman manager
      { appId = "com.github.marhkb.Pods"; origin = "flathub"; }
      # PrismLauncher, minecraft launcher
      { appId = "org.prismlauncher.PrismLauncher"; origin = "flathub"; }
      # Protonmail-bridge
      { appId = "ch.protonmail.protonmail-bridge"; origin = "flathub"; }
      # Signal
      { appId = "org.signal.Signal"; origin = "flathub"; }
      # SimpleX Chat
      { appId = "chat.simplex.simplex"; origin = "flathub"; }
      # Snoop, search through file contents (rather than just names)
      { appId = "de.philippun1.Snoop"; origin = "flathub"; }
      # Sober, for roblox
      { appId = "org.vinegarhq.Sober"; origin = "flathub"; }
      # Tor Browser
      { appId = "org.torproject.torbrowser-launcher"; origin = "flathub"; }
      # Torrhunt
      { appId = "com.ktechpit.torrhunt"; origin = "flathub"; }
      # Video wallpaper
      { appId = "io.github.jeffshee.Hidamari"; origin = "flathub"; }
      # Warehouse, flatpak manager
      { appId = "io.github.flattool.Warehouse"; origin = "flathub"; }
      # Warp, a wormhole client
      { appId = "app.drey.Warp"; origin = "flathub"; }
      # WiVRn, SteamVR alternative
      { appId = "io.github.wivrn.wivrn"; origin = "flathub"; }
    ];
  };
  # Flatpak requires this functionality
  security.unprivilegedUsernsClone = config.services.flatpak.enable;
}
