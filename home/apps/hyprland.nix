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
        hl.exec_cmd("[ -f $HOME/.config/hypr/colors.lua ] || wallust cs $HOME/.config/wallust/colorschemes/${profile.customization.color.defaultPreset}.json && hyprctl reload")
    end)
  '';


  xdg.configFile."hypr/input.lua".text = ''
    hl.config({
        input = {
            kb_layout  = "${profile.customization.keyboard.layout}",
            kb_variant = "",
            kb_model   = "",
            kb_options = "${profile.customization.keyboard.switchOption}",
            kb_rules   = "",

            numlock_by_default = true,

            follow_mouse = 1,
            sensitivity = 1,
            accel_profile = "flat",
        },
    })
  '';

  xdg.configFile."hypr/animations.lua".source     = ../../dotfiles/config/hypr/animations.lua;
  xdg.configFile."hypr/binds.lua".source          = ../../dotfiles/config/hypr/binds.lua;
  xdg.configFile."hypr/gestures.lua".source       = ../../dotfiles/config/hypr/gestures.lua;
  xdg.configFile."hypr/hyprland.lua".source       = ../../dotfiles/config/hypr/hyprland.lua;
  xdg.configFile."hypr/look.lua".source           = ../../dotfiles/config/hypr/look.lua;
  xdg.configFile."hypr/programs.lua".source       = ../../dotfiles/config/hypr/programs.lua;
  xdg.configFile."hypr/scrolloverview.lua".source = ../../dotfiles/config/hypr/scrolloverview.lua;
  xdg.configFile."hypr/windowrules.lua".source    = ../../dotfiles/config/hypr/windowrules.lua;
}