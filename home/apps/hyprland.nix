{ pkgs, profile, ... }:
{
  xdg.configFile."hypr/env.lua".text = ''
    hl.env("XCURSOR_THEME", "${profile.cursor.theme}")
    hl.env("XCURSOR_SIZE", "${toString profile.cursor.size}")
    hl.env("HYPRCURSOR_SIZE", "${toString profile.cursor.size}")
  '';

  xdg.configFile."hypr/hyprland.lua".source    = ../../dotfiles/config/hypr/hyprland.lua;
  xdg.configFile."hypr/programs.lua".source    = ../../dotfiles/config/hypr/programs.lua;
  xdg.configFile."hypr/look.lua".source        = ../../dotfiles/config/hypr/look.lua;
  xdg.configFile."hypr/input.lua".source       = ../../dotfiles/config/hypr/input.lua;
  xdg.configFile."hypr/binds.lua".source       = ../../dotfiles/config/hypr/binds.lua;
  xdg.configFile."hypr/windowrules.lua".source = ../../dotfiles/config/hypr/windowrules.lua;
  xdg.configFile."hypr/gestures.lua".source    = ../../dotfiles/config/hypr/gestures.lua;
  xdg.configFile."hypr/autostart.lua".source = ../../dotfiles/config/hypr/autostart.lua;
}