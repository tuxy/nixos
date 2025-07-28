# Generated via dconf2nix: https://github.com/gvolpe/dconf2nix
{lib, ...}:
with lib.hm.gvariant; {
  dconf.settings = {
    "com/usebottles/bottles" = {
      window-height = 640;
      window-width = 880;
    };

    "org/gnome/Console" = {
      last-window-maximised = true;
      last-window-size = mkTuple [732 528];
    };

    "org/gnome/Extensions" = {
      window-maximized = true;
    };

    "org/gnome/baobab/ui" = {
      is-maximized = false;
      window-size = mkTuple [960 600];
    };

    "org/gnome/calendar" = {
      active-view = "month";
      window-maximized = true;
      window-size = mkTuple [768 600];
    };

    "org/gnome/clocks/state/window" = {
      maximized = false;
      panel-id = "world";
      size = mkTuple [870 690];
    };

    "org/gnome/control-center" = {
      last-panel = "display";
      window-state = mkTuple [980 640 false];
    };

    "org/gnome/desktop/app-folders" = {
      folder-children = ["System" "Utilities" "YaST" "Pardus" "945b1483-052a-4351-a8d5-abe6286ba3cb" "6de37689-a69d-4877-83f4-33e39327d4c5" "1386f51c-50f2-4574-a6d2-92489fc94f99" "31d3715f-39d2-4b2f-ae34-1ac7e0e7baff" "08c52dd8-2242-43b7-8275-1f0aca1756c2"];
    };

    "org/gnome/desktop/app-folders/folders/08c52dd8-2242-43b7-8275-1f0aca1756c2" = {
      apps = ["mpv.desktop" "org.darktable.darktable.desktop" "BambuStudio.desktop" "org.qbittorrent.qBittorrent.desktop" "vlc.desktop" "figma-linux.desktop" "org.flameshot.Flameshot.desktop"];
      name = "Media";
      translate = false;
    };

    "org/gnome/desktop/app-folders/folders/1386f51c-50f2-4574-a6d2-92489fc94f99" = {
      apps = ["org.kicad.gerbview.desktop" "org.kicad.pcbcalculator.desktop" "org.kicad.pcbnew.desktop" "org.kicad.bitmap2component.desktop" "org.kicad.kicad.desktop"];
      name = "KiCAD";
      translate = false;
    };

    "org/gnome/desktop/app-folders/folders/31d3715f-39d2-4b2f-ae34-1ac7e0e7baff" = {
      apps = ["Ravenfield.desktop" "Kerbal Space Program.desktop" "Insurgency.desktop" "BeamNG.drive.desktop" "UNBEATABLE [white label].desktop" "Muse Dash.desktop" "Schedule I.desktop" "Euro Truck Simulator 2.desktop" "ckan.desktop" "Cloud Cutter.desktop" "DiRT Rally.desktop" "Cities Skylines.desktop" "METAL GEAR SOLID V THE PHANTOM PAIN.desktop" "Team Fortress 2.desktop" "Tell Me Why.desktop" "Garry's Mod.desktop" "Stardew Valley.desktop" "Unturned.desktop" "METAL GEAR SOLID V GROUND ZEROES.desktop"];
      name = "Steam Games";
      translate = false;
    };

    "org/gnome/desktop/app-folders/folders/6de37689-a69d-4877-83f4-33e39327d4c5" = {
      apps = ["com.obsproject.Studio.desktop" "org.prismlauncher.PrismLauncher.desktop" "Mindustry.desktop" "sunshine.desktop" "PCSX2.desktop" "com.vysp3r.ProtonPlus.desktop" "steam-rom-manager.desktop"];
      name = "Gaming";
      translate = false;
    };

    "org/gnome/desktop/app-folders/folders/945b1483-052a-4351-a8d5-abe6286ba3cb" = {
      apps = ["org.gnome.Console.desktop" "org.gnome.Snapshot.desktop" "org.gnome.Settings.desktop" "org.gnome.Tour.desktop" "simple-scan.desktop" "org.gnome.clocks.desktop" "org.gnome.Weather.desktop" "org.gnome.Decibels.desktop" "org.gnome.Extensions.desktop" "com.mattjakeman.ExtensionManager.desktop"];
      name = "GNOME";
      translate = false;
    };

    "org/gnome/desktop/app-folders/folders/Pardus" = {
      categories = ["X-Pardus-Apps"];
      name = "X-Pardus-Apps.directory";
      translate = true;
    };

    "org/gnome/desktop/app-folders/folders/System" = {
      apps = ["org.gnome.baobab.desktop" "org.gnome.DiskUtility.desktop" "org.gnome.Logs.desktop" "org.gnome.SystemMonitor.desktop"];
      name = "X-GNOME-Shell-System.directory";
      translate = true;
    };

    "org/gnome/desktop/app-folders/folders/Utilities" = {
      apps = ["org.gnome.Connections.desktop" "org.gnome.Evince.desktop" "org.gnome.FileRoller.desktop" "org.gnome.font-viewer.desktop" "org.gnome.Loupe.desktop" "org.gnome.seahorse.Application.desktop"];
      name = "X-GNOME-Shell-Utilities.directory";
      translate = true;
    };

    "org/gnome/desktop/app-folders/folders/YaST" = {
      categories = ["X-SuSE-YaST"];
      name = "suse-yast.directory";
      translate = true;
    };

    "org/gnome/desktop/background" = {
      color-shading-type = "solid";
      picture-options = "zoom";
      picture-uri = "file:///run/current-system/sw/share/backgrounds/gnome/map-l.svg";
      picture-uri-dark = "file:///run/current-system/sw/share/backgrounds/gnome/map-d.svg";
      primary-color = "#241f31";
      secondary-color = "#000000";
    };

    "org/gnome/desktop/datetime" = {
      automatic-timezone = true;
    };

    "org/gnome/desktop/input-sources" = {
      mru-sources = [(mkTuple ["xkb" "us"])];
      sources = [(mkTuple ["xkb" "us"]) (mkTuple ["xkb" "us+colemak_dh"])];
      xkb-options = ["terminate:ctrl_alt_bksp"];
    };

    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      enable-hot-corners = false;
      show-battery-percentage = true;
    };

    "org/gnome/desktop/notifications" = {
      application-children = ["gnome-power-panel" "steam" "chromium-browser" "org-gnome-nautilus" "alacritty" "org-gnome-texteditor" "android-studio" "org-darktable-darktable" "org-gnome-shell-extensions-gsconnect" "org-gnome-baobab"];
    };

    "org/gnome/desktop/notifications/application/alacritty" = {
      application-id = "Alacritty.desktop";
    };

    "org/gnome/desktop/notifications/application/android-studio" = {
      application-id = "android-studio.desktop";
    };

    "org/gnome/desktop/notifications/application/chromium-browser" = {
      application-id = "chromium-browser.desktop";
    };

    "org/gnome/desktop/notifications/application/firefox" = {
      application-id = "firefox.desktop";
    };

    "org/gnome/desktop/notifications/application/gnome-power-panel" = {
      application-id = "gnome-power-panel.desktop";
    };

    "org/gnome/desktop/notifications/application/org-darktable-darktable" = {
      application-id = "org.darktable.darktable.desktop";
    };

    "org/gnome/desktop/notifications/application/org-gnome-baobab" = {
      application-id = "org.gnome.baobab.desktop";
    };

    "org/gnome/desktop/notifications/application/org-gnome-console" = {
      application-id = "org.gnome.Console.desktop";
    };

    "org/gnome/desktop/notifications/application/org-gnome-nautilus" = {
      application-id = "org.gnome.Nautilus.desktop";
    };

    "org/gnome/desktop/notifications/application/org-gnome-shell-extensions-gsconnect" = {
      application-id = "org.gnome.Shell.Extensions.GSConnect.desktop";
    };

    "org/gnome/desktop/notifications/application/org-gnome-texteditor" = {
      application-id = "org.gnome.TextEditor.desktop";
    };

    "org/gnome/desktop/notifications/application/steam" = {
      application-id = "steam.desktop";
    };

    "org/gnome/desktop/peripherals/mouse" = {
      accel-profile = "flat";
    };

    "org/gnome/desktop/peripherals/touchpad" = {
      natural-scroll = true;
      two-finger-scrolling-enabled = true;
    };

    "org/gnome/desktop/screensaver" = {
      idle-activation-enabled = true;
    };

    "org/gnome/desktop/session" = {
      idle-delay = mkUint32 600;
    };

    "org/gnome/desktop/sound" = {
      event-sounds = false;
      theme-name = "__custom";
    };

    "org/gnome/desktop/wm/keybindings" = {
      switch-applications = [];
      switch-applications-backward = [];
      switch-windows = ["<Alt>Tab"];
      switch-windows-backward = ["<Shift><Alt>Tab"];
    };

    "org/gnome/evolution-data-server" = {
      migrated = true;
    };

    "org/gnome/file-roller/dialogs/extract" = {
      height = 800;
      recreate-folders = true;
      skip-newer = false;
      width = 1000;
    };

    "org/gnome/file-roller/file-selector" = {
      show-hidden = false;
      sidebar-size = 300;
      sort-method = "name";
      sort-type = "ascending";
      window-size = mkTuple [(-1) (-1)];
    };

    "org/gnome/file-roller/listing" = {
      list-mode = "as-folder";
      name-column-width = 67;
      show-path = false;
      sort-method = "size";
      sort-type = "ascending";
    };

    "org/gnome/file-roller/ui" = {
      sidebar-width = 200;
      window-height = 480;
      window-width = 600;
    };

    "org/gnome/mutter" = {
      dynamic-workspaces = true;
      edge-tiling = true;
    };

    "org/gnome/nautilus/icon-view" = {
      default-zoom-level = "medium";
    };

    "org/gnome/nautilus/preferences" = {
      default-folder-viewer = "icon-view";
      migrated-gtk-settings = true;
      search-filter-time-type = "last_modified";
    };

    "org/gnome/nautilus/window-state" = {
      initial-size = mkTuple [890 550];
      initial-size-file-chooser = mkTuple [890 550];
      maximized = true;
    };

    "org/gnome/nm-applet/eap/dfb78d85-974a-4914-a32a-4c4e0e60ca84" = {
      ignore-ca-cert = true;
      ignore-phase2-ca-cert = false;
    };

    "org/gnome/nm-applet/eap/ed9ec09c-4d04-4ed9-a09e-a5f414b4a326" = {
      ignore-ca-cert = true;
      ignore-phase2-ca-cert = false;
    };

    "org/gnome/portal/filechooser/Alacritty" = {
      last-folder-path = "/home/tuxy/Documents/projects/qmk_firmware/keyboards/cantor/keymaps/default";
    };

    "org/gnome/portal/filechooser/chromium-browser" = {
      last-folder-path = "/home/tuxy/.ssh";
    };

    "org/gnome/portal/filechooser/codium" = {
      last-folder-path = "/home/tuxy/Documents/projects/mobile-nixos";
    };

    "org/gnome/portal/filechooser/org/gnome/TextEditor" = {
      last-folder-path = "/home/tuxy/Documents/projects/qmk_firmware/keyboards/cantor/keymaps/tuxy";
    };

    "org/gnome/settings-daemon/plugins/color" = {
      night-light-enabled = true;
      night-light-schedule-automatic = false;
      night-light-schedule-from = 16.0;
      night-light-temperature = mkUint32 2607;
    };

    "org/gnome/settings-daemon/plugins/power" = {
      idle-dim = true;
      power-saver-profile-on-low-battery = true;
      sleep-inactive-ac-type = "suspend";
      sleep-inactive-battery-type = "suspend";
    };

    "org/gnome/shell/app-switcher" = {
      current-workspace-only = true;
    };

    "org/gnome/shell/extensions/gsconnect" = {
      devices = ["5bfd1cf9_27d5_4132_b538_65c5357c090c"];
      name = "nixos";
    };

    "org/gnome/shell/extensions/gsconnect/device/5bfd1cf9_27d5_4132_b538_65c5357c090c" = {
      certificate-pem = "-----BEGIN CERTIFICATE-----nMIIBlDCCATmgAwIBAgIBATAKBggqhkjOPQQDBDBTMS0wKwYDVQQDDCQ1YmZkMWNmnOV8yN2Q1XzQxMzJfYjUzOF82NWM1MzU3YzA5MGMxFDASBgNVBAsMC0tERSBDb25unZWN0MQwwCgYDVQQKDANLREUwHhcNMjIxMjEzMTcwMDAwWhcNMzIxMjEzMTcwMDAwnWjBTMS0wKwYDVQQDDCQ1YmZkMWNmOV8yN2Q1XzQxMzJfYjUzOF82NWM1MzU3YzA5nMGMxFDASBgNVBAsMC0tERSBDb25uZWN0MQwwCgYDVQQKDANLREUwWTATBgcqhkjOnPQIBBggqhkjOPQMBBwNCAASCybxLLl6YC2CNQBxagb1DtLBArkQHO5VzJYa3oOmgnOyOTknxfyNaE8Ao24lAYU3zKCknALoabEnaXkntRwkyWMAoGCCqGSM49BAMEA0kAnMEYCIQDOyI0oUphWdMffw4WtLtICYKlL9fjCzfifkpWnpN3gYwIhAPxN/rmD57u3nXZVYA6i47aKiYHzXp/C39R/8HXe5Dk5vn-----END CERTIFICATE-----n";
      incoming-capabilities = ["kdeconnect.battery" "kdeconnect.bigscreen.stt" "kdeconnect.clipboard" "kdeconnect.clipboard.connect" "kdeconnect.contacts.request_all_uids_timestamps" "kdeconnect.contacts.request_vcards_by_uid" "kdeconnect.findmyphone.request" "kdeconnect.mousepad.keyboardstate" "kdeconnect.mousepad.request" "kdeconnect.mpris" "kdeconnect.mpris.request" "kdeconnect.notification" "kdeconnect.notification.action" "kdeconnect.notification.reply" "kdeconnect.notification.request" "kdeconnect.ping" "kdeconnect.runcommand" "kdeconnect.sftp.request" "kdeconnect.share.request" "kdeconnect.share.request.update" "kdeconnect.sms.request" "kdeconnect.sms.request_attachment" "kdeconnect.sms.request_conversation" "kdeconnect.sms.request_conversations" "kdeconnect.systemvolume" "kdeconnect.telephony.request" "kdeconnect.telephony.request_mute"];
      last-connection = "lan://192.168.100.101:1716";
      name = "Pixel 5";
      outgoing-capabilities = ["kdeconnect.battery" "kdeconnect.bigscreen.stt" "kdeconnect.clipboard" "kdeconnect.clipboard.connect" "kdeconnect.connectivity_report" "kdeconnect.contacts.response_uids_timestamps" "kdeconnect.contacts.response_vcards" "kdeconnect.findmyphone.request" "kdeconnect.mousepad.echo" "kdeconnect.mousepad.keyboardstate" "kdeconnect.mousepad.request" "kdeconnect.mpris" "kdeconnect.mpris.request" "kdeconnect.notification" "kdeconnect.notification.request" "kdeconnect.ping" "kdeconnect.presenter" "kdeconnect.runcommand.request" "kdeconnect.sftp" "kdeconnect.share.request" "kdeconnect.sms.attachment_file" "kdeconnect.sms.messages" "kdeconnect.systemvolume.request" "kdeconnect.telephony"];
      paired = true;
      supported-plugins = ["battery" "clipboard" "connectivity_report" "contacts" "findmyphone" "mousepad" "mpris" "notification" "ping" "presenter" "runcommand" "sftp" "share" "sms" "systemvolume" "telephony"];
      type = "phone";
    };

    "org/gnome/shell/extensions/gsconnect/device/5bfd1cf9_27d5_4132_b538_65c5357c090c/plugin/battery" = {
      custom-battery-notification-value = mkUint32 80;
    };

    "org/gnome/shell/extensions/gsconnect/device/5bfd1cf9_27d5_4132_b538_65c5357c090c/plugin/notification" = {
      applications = ''
        {"Printers":{"iconName":"org.gnome.Settings-printers-symbolic","enabled":true},"Bottles":{"iconName":"com.usebottles.bottles","enabled":true},"Events and Tasks Reminders":{"iconName":"org.gnome.Evolution-alarm-notify","enabled":true},"Disks":{"iconName":"org.gnome.DiskUtility","enabled":true},"Date & Time":{"iconName":"org.gnome.Settings-time-symbolic","enabled":true},"Lutris":{"iconName":"net.lutris.Lutris","enabled":true},"Disk Usage Analyzer":{"iconName":"org.gnome.baobab","enabled":true},"Power":{"iconName":"org.gnome.Settings-power-symbolic","enabled":true},"Console":{"iconName":"org.gnome.Console","enabled":true},"Color Management":{"iconName":"org.gnome.Settings-color-symbolic","enabled":true},"Files":{"iconName":"org.gnome.Nautilus","enabled":true},"Clocks":{"iconName":"org.gnome.clocks","enabled":true},"File Roller":{"iconName":"org.gnome.FileRoller","enabled":true},"Chromium":{"iconName":"file:///tmp/.org.chromium.Chromium.pmw5rj/logo.png","enabled":true},"Disk Space":{"iconName":"","enabled":true}}\n
      '';
    };

    "org/gnome/shell/extensions/gsconnect/device/5bfd1cf9_27d5_4132_b538_65c5357c090c/plugin/share" = {
      receive-directory = "/home/tuxy/Downloads";
    };

    "org/gnome/shell/extensions/gsconnect/preferences" = {
      window-maximized = false;
      window-size = mkTuple [790 460];
    };

    "org/gnome/shell/extensions/libpanel" = {
      layout = [["gnome@main" "quick-settings-audio-panel@rayzeq.github.io/main"]];
    };

    "org/gnome/shell/extensions/quick-settings-audio-panel" = {
      version = 2;
    };

    "org/gnome/shell/world-clocks" = {
      locations = [];
    };

    "org/gtk/gtk4/settings/file-chooser" = {
      show-hidden = true;
    };

    "org/gtk/settings/file-chooser" = {
      date-format = "regular";
      location-mode = "path-bar";
      show-hidden = false;
      show-size-column = true;
      show-type-column = true;
      sidebar-width = 167;
      sort-column = "name";
      sort-directories-first = false;
      sort-order = "ascending";
      type-format = "category";
      window-position = mkTuple [26 23];
      window-size = mkTuple [1203 902];
    };

    "system/proxy" = {
      ignore-hosts = ["localhost,127.0.0.0/8,::1"];
      mode = "none";
    };

    "system/proxy/ftp" = {
      host = "127.0.0.1";
      port = 2080;
    };

    "system/proxy/http" = {
      host = "127.0.0.1";
      port = 2080;
    };

    "system/proxy/https" = {
      host = "127.0.0.1";
      port = 2080;
    };

    "system/proxy/socks" = {
      host = "127.0.0.1";
      port = 2080;
    };
  };
}
