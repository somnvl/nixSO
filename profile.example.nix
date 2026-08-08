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
    # Shared by cursor.nix, hyprland.nix (env vars) and niri.nix (cursor.kdl)
    # so the three can't drift out of sync.
    cursor = {
      theme = "miku";
      size = 24;
    };
  };

  # Per-output config for niri, generated into outputs.kdl at build time —
  # never hardcoded in dotfiles/config/niri/config.kdl, keeps that file
  # generic/public. Hyprland sets its own monitor scale directly in
  # hyprland.lua (wildcard/auto config, no per-machine values needed).
  # Leave empty to let niri auto-detect everything.
  # Find connector names with `niri msg outputs` from inside a niri session.
  displays = [
    # {
    #   connector = "eDP-1";
    #   scale = 1.0;
    # }
  ];

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

      # DRM render node niri.nix uses (gpu.kdl) for the compositor's own
      # rendering. On an internal-panel-only laptop (no external monitor
      # wired to the Nvidia GPU), point this at the AMD node — otherwise
      # niri composing on Nvidia forces a needless inter-GPU buffer
      # round-trip every frame. Only use the Nvidia node if an external
      # display is physically wired to it (see niri issue #3674).
      # Hyprland is unaffected, doesn't need this.
      #
      # Find yours:
      #   for c in /sys/class/drm/card*/device/driver; do echo "$c -> $(readlink -f "$c")"; done
      #   readlink -f /sys/class/drm/cardN/device/drm/renderD*
      renderDevice = "/dev/dri/renderD0";
    };
  };

  # ─────────────────────────────────────────────────────────────────────
  # Debug/diagnostic workarounds — almost certainly NOT relevant to you.
  # ─────────────────────────────────────────────────────────────────────
  # Found while chasing a specific flicker bug on one exact laptop (AMD
  # Ryzen AI 7 350 + Nvidia RTX 5060 Laptop, hybrid PRIME offload). None
  # were confirmed as the actual root cause — kept here, off by default,
  # because each is a real fix for a real but different/more general known
  # issue that may or may not apply to your hardware. Don't enable blindly.
  workarounds = {
    # amdgpu.dcdebugmask=0x10 (system/boot.nix) — disables AMD Panel Self
    # Refresh. Real fix for a PSR flicker/freeze bug on some Strix/Krackan
    # Point AMD laptop APUs — did NOT fix the flicker this was added to
    # chase. Costs some battery life if you don't have that bug.
    disablePsr = false;

    # GSK_RENDERER=ngl (home/gtk.nix) — forces GTK4's own renderer. Tried
    # to rule out a Nautilus-specific flicker; inconclusive (the flicker
    # also hit non-GTK apps). Harmless to enable, never confirmed needed.
    gtk4Renderer = false;

    # disable-direct-scanout + disable-cursor-plane in niri's gpu.kdl, on
    # top of the baseline nvidiaPrime.enable fix. Forces full software
    # composition — real perf/battery cost. Never confirmed to fix
    # anything. Only applies under hardware.nvidiaPrime.enable = true.
    niriScanoutWorkarounds = false;
  };
}