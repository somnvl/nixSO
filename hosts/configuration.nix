{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./hardware.nix
#    ./hardware-nvidia.nix

    ../system/aliases.nix
    ../system/boot.nix
    ../system/core.nix
    ../system/desktop.nix
    ../system/fonts.nix
    ../system/network.nix
    ../system/users.nix
  ];

  networking.hostName = "nixSO";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Paris";
  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "fr";

  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # stateVersion must match the NixOS version you first installed with.
  # Do not change this after the initial installation
  system.stateVersion = "26.05";
}