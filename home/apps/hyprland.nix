{ config, pkgs, profile, ... }:
let
  scrolloverview = pkgs.callPackage ../packages/hyprland-scroll-overview.nix { };

  colorDefaults = builtins.fromJSON (builtins.readFile ../../dotfiles/config/quickshell/config-defaults/color.json);
  fallbackPreset = builtins.fromJSON (builtins.readFile
    ../../dotfiles/config/wallust/colorschemes/${colorDefaults.activePreset}.json);

  hyprDots = "${profile.user.repoPath}/dotfiles/config/hypr";
in
{
  xdg.configFile."hypr/env.lua".text = ''
    hl.env("XCURSOR_THEME", "${profile.customization.cursor.theme}")
    hl.env("XCURSOR_SIZE", "${toString profile.customization.cursor.size}")
    hl.env("HYPRCURSOR_SIZE", "${toString profile.customization.cursor.size}")
  '';

  xdg.configFile."hypr/colors-fallback.lua".text = ''
    return {
        background = "${fallbackPreset.special.background}",
        foreground = "${fallbackPreset.special.foreground}",
        cursor     = "${fallbackPreset.special.cursor}",
        color4     = "${fallbackPreset.colors.color4}",
        color8     = "${fallbackPreset.colors.color8}",
    }
  '';

  xdg.configFile."hypr/autostart.lua".text = ''
    hl.on("hyprland.start", function()
        hl.exec_cmd("hyprctl plugin load ${scrolloverview}/lib/libscrolloverview.so")
        hl.exec_cmd("quickshell")
        hl.exec_cmd("[ -f $HOME/.config/hypr/colors.lua ] || wallust cs $HOME/.config/wallust/colorschemes/$(jq -r .activePreset $HOME/.config/quickshell/config-defaults/color.json).json && hyprctl reload")
    end)
  '';

  xdg.configFile."hypr/input.lua".text = ''
    hl.config({
        input = {
            kb_layout  = "${profile.customization.keyboard.layout}",
            kb_variant = "",
            kb_model   = "",
            kb_options = "",
            kb_rules   = "",

            numlock_by_default = true,

            follow_mouse = 1,
            sensitivity = 1,
            accel_profile = "flat",
        },
    })
  '';

  xdg.configFile."hypr/animations.lua".source     = config.lib.file.mkOutOfStoreSymlink "${hyprDots}/animations.lua";
  xdg.configFile."hypr/binds.lua".source          = config.lib.file.mkOutOfStoreSymlink "${hyprDots}/binds.lua";
  xdg.configFile."hypr/gestures.lua".source       = config.lib.file.mkOutOfStoreSymlink "${hyprDots}/gestures.lua";
  xdg.configFile."hypr/hyprland.lua".source       = config.lib.file.mkOutOfStoreSymlink "${hyprDots}/hyprland.lua";
  xdg.configFile."hypr/look.lua".source           = config.lib.file.mkOutOfStoreSymlink "${hyprDots}/look.lua";
  xdg.configFile."hypr/programs.lua".source       = config.lib.file.mkOutOfStoreSymlink "${hyprDots}/programs.lua";
  xdg.configFile."hypr/scrolloverview.lua".source = config.lib.file.mkOutOfStoreSymlink "${hyprDots}/scrolloverview.lua";
  xdg.configFile."hypr/windowrules.lua".source    = config.lib.file.mkOutOfStoreSymlink "${hyprDots}/windowrules.lua";
}