{ ... }:

{
  programs.plasma = {
    enable = true;

    workspace = {
      # Look and feel
      lookAndFeel = "org.kde.breezedark.desktop";
      colorScheme = "BreezeDark";

      # Cursor settings
      cursor = {
        theme = "breeze_cursors";
        size = 24;
      };

      # Icon theme
      iconTheme = "breeze-dark";

      # Window theme
      windowDecorations = {
        library = "org.kde.breeze";
        theme = "Breeze";
      };
    };

    # Desktop settings
    desktop = {
      mouseActions = {
        middleClick = "applicationlauncher";
      };
    };

    # Panel configuration
    panels = [
      {
        location = "bottom";
        height = 44;
        widgets = [
          "org.kde.plasma.kickoff"
          "org.kde.plasma.pager"
          "org.kde.plasma.icontasks"
          "org.kde.plasma.marginsseparator"
          "org.kde.plasma.systemtray"
          "org.kde.plasma.digitalclock"
          "org.kde.plasma.showdesktop"
        ];
      }
    ];

    # Shortcuts
    shortcuts = {
      "kwin"."Switch to Desktop 1" = "Meta+1";
      "kwin"."Switch to Desktop 2" = "Meta+2";
      "kwin"."Switch to Desktop 3" = "Meta+3";
      "kwin"."Switch to Desktop 4" = "Meta+4";
      "kwin"."Window to Desktop 1" = "Meta+!";
      "kwin"."Window to Desktop 2" = "Meta+@";
      "kwin"."Window to Desktop 3" = "Meta+#";
      "kwin"."Window to Desktop 4" = "Meta+$";
      "org.kde.konsole.desktop"."_launch" = "Meta+Return";
      "org.kde.krunner.desktop"."_launch" = "Meta+Space";
    };

    # Window management
    kwin = {
      virtualDesktops = {
        rows = 1;
        number = 4;
        names = [ "Main" "Work" "Media" "Misc" ];
      };

      effects = {
        desktopSwitching.animation = "slide";
        windowOpenClose.animation = "fade";
      };
    };

    # Input settings
    input = {
      keyboard = {
        layouts = [ { layout = "us"; } ];
        options = [ "caps:escape" ];
      };

      mouse = {
        acceleration = 0.0;
        accelerationProfile = "flat";
      };
    };

    # Power management
    powerdevil = {
      AC = {
        autoSuspend = {
          action = "nothing";
          idleTimeout = 10800; # 3 hours
        };
        turnOffDisplay = {
          idleTimeout = 1800; # 30 minutes
        };
      };

      battery = {
        autoSuspend = {
          action = "suspend";
          idleTimeout = 1800; # 30 minutes
        };
        turnOffDisplay = {
          idleTimeout = 600; # 10 minutes
        };
      };

      lowBattery = {
        autoSuspend = {
          action = "hibernate";
        };
      };
    };

    # Application settings
    configFile = {
      # Dolphin file manager
      "dolphinrc"."General"."BrowseThroughArchives" = true;
      "dolphinrc"."General"."ShowFullPath" = true;

      # Konsole terminal
      "konsolerc"."Desktop Entry"."DefaultProfile" = "Main.profile";
      "konsolerc"."UiSettings"."ColorScheme" = "Breeze";

      # Kate editor
      "katerc"."General"."Show Full Path in Title" = true;
      "katerc"."General"."Recent Files"."maxCount" = 20;
    };
  };
}
