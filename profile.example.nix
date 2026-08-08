{
  # Copy this file to profile.nix (in the same folder) and fill in your own
  # values. profile.nix is your personal, non-secret configuration — it lets
  # this flake stay usable as a public template while keeping your own
  # identity/settings out of the shared logic.
  #
  # Grouped into categories so a future settings UI can map one section to
  # one panel/tab instead of parsing a flat list of fields.

  system = {
    # System hostname (networking.hostName).
    hostname = "your-hostname";

    # System timezone (time.timeZone), e.g. "Europe/Paris", "America/New_York".
    timeZone = "Europe/Paris";

    # System locale (i18n.defaultLocale).
    locale = "en_US.UTF-8";

    # TTY console keyboard layout (console.keyMap), e.g. "fr", "us", "de".
    # Only affects the raw TTY before a graphical session starts — your
    # actual WM keyboard layout is set separately (input.lua for Hyprland,
    # the `input { keyboard { xkb { layout ... } } }` block for niri).
    consoleKeyMap = "fr";
  };

  user = {
    # Your Linux username — used as the NixOS user AND the home-manager
    # profile key.
    username = "your-username";

    # Local path where you clone this repo — used by the switchmyos/testmyos/
    # etc. shell aliases (system/aliases.nix) to know where to run
    # nixos-rebuild from. Change this if you clone somewhere other than
    # ~/nixSO.
    repoPath = "/home/your-username/nixSO";
  };

  git = {
    # Git identity (used if/when programs.git is wired up in home/apps).
    name = "your-name";

    # Tip: use your GitHub "noreply" email (Settings > Emails > Keep my email
    # address private) instead of your real one, to keep it out of a public
    # repo.
    email = "your-id+your-username@users.noreply.github.com";
  };

  # Pointer cursor — single source of truth shared between home-manager's
  # cursor package (cursor.nix), Hyprland's env vars (hyprland.nix), and
  # niri's generated cursor.kdl (niri.nix), so none of the three can drift
  # out of sync with each other.
  cursor = {
    theme = "miku";
    size = 24;
  };

  # Optional system features/services, toggled on or off — meant to be
  # flipped from a future settings UI without touching the modules below.
  features = {
    docker = true;
    # virtualbox = false;
    # steam = false;

    # Automatic Nix garbage collection + store optimisation.
    gc = {
      automatic = true;
      dates = "weekly";
      retention = "30d";
      optimiseAutomatic = true;
    };

    # Dev toolchains in home.packages, per stack — off by default so
    # forking this repo doesn't pull in tools you don't need.
    devTools  = true;  # gnumake, ripgrep, fd — generic dev CLI tools
    cDev      = true;  # clang, norminette, valgrind, gdb, SDL2...
    pythonDev = true;  # python314 + common libs, ruff, pyright, black
    goDev     = true;  # go, gopls, gotools
    wailsDev  = true;  # go + node + GTK/webkit dev headers
  };

  # Enable if you have the same hybrid AMD iGPU + Nvidia dGPU laptop setup
  # (PRIME sync/offload). Leave false otherwise — the bus IDs below are
  # specific to one exact machine, not safe to apply blindly elsewhere.
  # Find yours with `lspci | grep -E "VGA|3D"`.
  nvidiaPrime = {
    enable = false;

    # PCI bus IDs for the AMD/Nvidia PRIME offload config, in
    # "PCI:bus:device:function" (decimal, not hex) format, as reported by
    # `lspci`.
    amdgpuBusId = "PCI:0:0:0";
    nvidiaBusId = "PCI:0:0:0";

    # DRM render node for the Nvidia GPU — only consumed by niri.nix (via
    # gpu.kdl) to work around flicker/artifacts on hybrid AMD+Nvidia setups
    # under niri, by forcing rendering onto the Nvidia device explicitly and
    # enabling the `wait-for-frame-completion-before-queueing` debug flag.
    # Hyprland doesn't need this — it's unaffected by the same bug.
    #
    # Find yours:
    #   1. Confirm which card is Nvidia:
    #      for c in /sys/class/drm/card*/device/driver; do echo "$c -> $(readlink -f "$c")"; done
    #   2. Get its render node:
    #      readlink -f /sys/class/drm/cardN/device/drm/renderD*
    renderDevice = "/dev/dri/renderD0";
  };

  # Per-output config for niri (generated into outputs.kdl at build time via
  # niri.nix — never hardcoded in dotfiles/config/niri/config.kdl, to keep
  # that file generic/public). Hyprland's equivalent (monitor scale etc.) is
  # set directly in hyprland.lua since it already uses a wildcard/auto
  # config that doesn't need per-machine values.
  #
  # Leave this list empty to let niri auto-detect scale/mode/position for
  # every connected output.
  #
  # Find your connector name(s) with `niri msg outputs` while inside a niri
  # session.
  displays = [
    # {
    #   connector = "eDP-1";
    #   scale = 1.0;
    # }
  ];
}