{ ... }:
{
  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  programs.niri.enable = true;

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
  };

  services.gvfs.enable = true;
}