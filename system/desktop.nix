{ ... }:
{
  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  programs.niri.enable = true;

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  services.gvfs.enable = true;
}