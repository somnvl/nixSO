{ profile, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./hardware-graphics.nix
    ./hardware.nix

    ../system/aliases.nix
    ../system/boot.nix
    ../system/core.nix
    ../system/desktop.nix
    ../system/docker.nix
    ../system/fonts.nix
    ../system/network.nix
    ../system/sddm.nix
    ../system/users.nix
  ];

  networking.hostName = profile.system.hostname;
  networking.networkmanager.enable = true;

  time.timeZone = profile.system.timeZone;
  i18n.defaultLocale = profile.system.locale;
  console.keyMap = profile.system.consoleKeyMap;

  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  nix.gc = {
    automatic = profile.features.gc.automatic;
    dates = profile.features.gc.dates;
    options = "--delete-older-than ${profile.features.gc.retention}";
  };
  nix.optimise.automatic = profile.features.gc.optimiseAutomatic;

  # stateVersion must match the NixOS version you first installed with.
  # Do not change this after the initial installation
  system.stateVersion = "26.05";
}