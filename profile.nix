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
    hostname = "nixSO";

    # System timezone (time.timeZone), e.g. "Europe/Paris", "America/New_York"
    timeZone = "Europe/Paris";

    # System locale (i18n.defaultLocale)
    locale = "en_US.UTF-8";

    # TTY console keyboard layout (console.keyMap), e.g. "fr", "us", "de"
    consoleKeyMap = "fr";
  };

  user = {
    # Your Linux username — used as the NixOS user AND the home-manager profile key
    username = "so";

    # Local path where you clone this repo — used by the switchmyos/testmyos/etc.
    # shell aliases. Change this if you clone somewhere other than ~/nixSO.
    repoPath = "/home/so/nixSO";
  };

  git = {
    # Git identity (used if/when programs.git is wired up in home/apps)
    name = "somnvl";

    # Tip: use your GitHub "noreply" email (Settings > Emails > Keep my email
    # address private) instead of your real one, to keep it out of a public repo.
    email = "186089420+somnvl@users.noreply.github.com";
  };
}