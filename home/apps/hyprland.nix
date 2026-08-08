{ pkgs, profile, ... }:
let
  scrolloverview = pkgs.callPackage ../packages/hyprland-scroll-overview.nix { };
in
{
  xdg.configFile."hypr/env.lua".text = ''
    hl.env("XCURSOR_THEME", "${profile.customization.cursor.theme}")
    hl.env("XCURSOR_SIZE", "${toString profile.customization.cursor.size}")
    hl.env("HYPRCURSOR_SIZE", "${toString profile.customization.cursor.size}")
  '';

  xdg.configFile."hypr/autostart.lua".text = ''
    hl.on("hyprland.start", function()
        hl.exec_cmd("hyprctl plugin load ${scrolloverview}/lib/libscrolloverview.so")
        hl.exec_cmd("quickshell")
    end)
  '';

  xdg.configFile."hypr/animations.lua".source  = ../../dotfiles/config/hypr/animations.lua;
  xdg.configFile."hypr/binds.lua".source       = ../../dotfiles/config/hypr/binds.lua;
  xdg.configFile."hypr/gestures.lua".source    = ../../dotfiles/config/hypr/gestures.lua;
  xdg.configFile."hypr/hyprland.lua".source    = ../../dotfiles/config/hypr/hyprland.lua;
  xdg.configFile."hypr/input.lua".source       = ../../dotfiles/config/hypr/input.lua;
  xdg.configFile."hypr/look.lua".source        = ../../dotfiles/config/hypr/look.lua;
  xdg.configFile."hypr/programs.lua".source    = ../../dotfiles/config/hypr/programs.lua;
  xdg.configFile."hypr/scrolloverview.lua".source = ../../dotfiles/config/hypr/scrolloverview.lua;
  xdg.configFile."hypr/windowrules.lua".source = ../../dotfiles/config/hypr/windowrules.lua;
}