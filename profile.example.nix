{
  # Copy to profile.nix and fill in your own values.

  system = {
    hostname = "your-hostname";        # networking.hostName
    timeZone = "Europe/Paris";         # time.timeZone
    locale = "en_US.UTF-8";            # i18n.defaultLocale
    consoleKeyMap = "fr";              # TTY-only layout, before graphical session

    nix = {
      gc = {
        automatic = true;
        dates = "weekly";
        retention = "30d";
        optimiseAutomatic = true;
      };

      # Past generations kept in the systemd-boot menu.
      bootGenerationsLimit = 3;
    };
  };

  user = {
    # NixOS user + home-manager profile key.
    username = "your-username";

    # Where you clone this repo — used by switchmyos/testmyos aliases.
    repoPath = "/home/your-username/nixSO";

    git = {
      name = "your-name";
      # Use a GitHub noreply email to keep your real one out of a public repo.
      email = "your-id+your-username@users.noreply.github.com";
    };
  };

  # Ricing/theming choices.
  customization = {
    color = {
      defaultPreset = "e-ink-light";
    };

    # Shared by cursor.nix and hyprland.nix (env vars) so the two can't
    # drift out of sync.
    cursor = {
      theme = "miku";
      size = 24;
    };

    # kb_layout (comma-separated, first is default) and the XKB option
    # controlling how you switch between them — see the full option list:
    # https://man.archlinux.org/man/xkeyboard-config.7
    keyboard = {
      layout = "us";
      switchOption = "grp:alts_toggle";
    };

    wallpaper = {
      fitMode = "cover";
      transitionDuration = 1500;

      autorotate = {
        enable = false;
        folder = "/home/your-username/Pictures/wallpapers";
        frequencyMinutes = 60;
      };
    };
  };

  # Dev toolchains + dev-adjacent services, off by default so forking this
  # repo doesn't pull in tools you don't need.
  dev = {
    docker = false;

    devTools  = false;  # gnumake, ripgrep, fd
    cDev      = false;  # clang, norminette, valgrind, gdb, SDL2...
    pythonDev = false;  # python314 + common libs, ruff, pyright, black
    goDev     = false;  # go, gopls, gotools
    wailsDev  = false;  # go + node + GTK/webkit dev headers
  };

  # Machine-specific hardware config.
  hardware = {
    # Hybrid AMD iGPU + Nvidia dGPU laptop (PRIME offload). Leave false
    # otherwise — bus IDs below are specific to one exact machine.
    # Find yours with `lspci | grep -E "VGA|3D"`.
    nvidiaPrime = {
      enable = false;

      # "PCI:bus:device:function" (decimal, not hex), from `lspci`.
      amdgpuBusId = "PCI:0:0:0";
      nvidiaBusId = "PCI:0:0:0";
    };
  };

  # ─────────────────────────────────────────────────────────────────────
  # Debug/diagnostic — almost certainly NOT relevant to you.
  # ─────────────────────────────────────────────────────────────────────
  workarounds = {
    disablePsr = false;
  };
}