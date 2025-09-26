{ ... }:

{
  programs.plasma = {
    enable = true;

    workspace = {
      # Look and feel - Dark mode
      lookAndFeel = "org.kde.breezedark.desktop";
      colorScheme = "BreezeDark";
    };

    # All other customizations commented out for initial setup
    # Uncomment and test one section at a time after confirming basic build works

    # # Cursor settings
    # cursor = {
    #   theme = "breeze_cursors";
    #   size = 24;
    # };

    # # Icon theme
    # iconTheme = "breeze-dark";

    # # Window theme
    # windowDecorations = {
    #   library = "org.kde.breeze";
    #   theme = "Breeze";
    # };

    # # Desktop settings
    # desktop = {
    #   mouseActions = {
    #     middleClick = "applicationlauncher";
    #   };
    # };

    # Panel configuration
    panels = [
      {
        hiding = "autohide";
      }
    ];

    # # Shortcuts
    # shortcuts = {
    #   "kwin"."Switch to Desktop 1" = "Meta+1";
    #   "kwin"."Switch to Desktop 2" = "Meta+2";
    #   "kwin"."Switch to Desktop 3" = "Meta+3";
    #   "kwin"."Switch to Desktop 4" = "Meta+4";
    #   "kwin"."Window to Desktop 1" = "Meta+!";
    #   "kwin"."Window to Desktop 2" = "Meta+@";
    #   "kwin"."Window to Desktop 3" = "Meta+#";
    #   "kwin"."Window to Desktop 4" = "Meta+$";
    #   "org.kde.konsole.desktop"."_launch" = "Meta+Return";
    #   "org.kde.krunner.desktop"."_launch" = "Meta+Space";
    # };

    # # Window management
    # kwin = {
    #   virtualDesktops = {
    #     rows = 1;
    #     number = 4;
    #     names = [ "Main" "Work" "Media" "Misc" ];
    #   };

    #   effects = {
    #     desktopSwitching.animation = "slide";
    #     windowOpenClose.animation = "fade";
    #   };
    # };

    # # Input settings
    # input = {
    #   keyboard = {
    #     layouts = [ { layout = "us"; } ];
    #     options = [ "caps:escape" ];
    #   };
    # };

    # # Power management
    # powerdevil = {
    #   AC = {
    #     autoSuspend = {
    #       action = "nothing";
    #       idleTimeout = 10800; # 3 hours
    #     };
    #     turnOffDisplay = {
    #       idleTimeout = 1800; # 30 minutes
    #     };
    #   };

    #   battery = {
    #     autoSuspend = {
    #       action = "sleep";
    #       idleTimeout = 1800; # 30 minutes
    #     };
    #     turnOffDisplay = {
    #       idleTimeout = 600; # 10 minutes
    #     };
    #   };

    #   lowBattery = {
    #     autoSuspend = {
    #       action = "hibernate";
    #     };
    #   };
    # };

    # Application settings
    configFile = {
      # Dolphin file manager
      "dolphinrc"."DetailsMode"."PreviewSize" = 16;

      # # Konsole terminal
      # "konsolerc"."Desktop Entry"."DefaultProfile" = "Main.profile";
      # "konsolerc"."UiSettings"."ColorScheme" = "Breeze";

      # # Kate editor
      # "katerc"."General"."Show Full Path in Title" = true;
      # "katerc"."General"."Recent Files"."maxCount" = 20;
    };
  };
}
