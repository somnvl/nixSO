{
  # Copy this file to profile.nix (in the same folder) and fill in your own
  # values. profile.nix is your personal, non-secret configuration — it lets
  # this flake stay usable as a public template while keeping your own
  # identity/settings out of the shared logic.
  #
  # Grouped into categories so a future settings UI can map one section to
  # one panel/tab instead of parsing a flat list of fields.

  system = {
    # System hostname (networking.hostName)
    hostname = "your-hostname";

    # System timezone (time.timeZone), e.g. "Europe/Paris", "America/New_York"
    timeZone = "Europe/Paris";

    # System locale (i18n.defaultLocale)
    locale = "en_US.UTF-8";

    # TTY console keyboard layout (console.keyMap), e.g. "fr", "us", "de"
    consoleKeyMap = "fr";
  };

  user = {
    # Your Linux username — used as the NixOS user AND the home-manager profile key
    username = "your-username";

    # Local path where you clone this repo — used by the switchmyos/testmyos/etc.
    # shell aliases. Change this if you clone somewhere other than ~/nixSO.
    repoPath = "/home/your-username/nixSO";
  };

  git = {
    # Git identity (used if/when programs.git is wired up in home/apps)
    name = "your-name";

    # Tip: use your GitHub "noreply" email (Settings > Emails > Keep my email
    # address private) instead of your real one, to keep it out of a public repo.
    email = "your-id+your-username@users.noreply.github.com";
  };

  # Pointer cursor — single source of truth shared between home-manager's
  # cursor package (cursor.nix) and Hyprland's env vars (hyprland.nix),
  # so the two can never drift out of sync.
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
    amdgpuBusId = "PCI:0:0:0";
    nvidiaBusId = "PCI:0:0:0";
  };
}