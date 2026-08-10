{ pkgs, ... }:
{
  home.packages = with pkgs; [
    (writeShellScriptBin "wall" ''
      exec qs ipc call wallpaper "$@"
    '')
    (writeShellScriptBin "theme" ''
      exec qs ipc call color "$@"
    '')

    (writeShellScriptBin "wallset" ''
      exec qs ipc call wallpaper set "$(realpath "$1")"
    '')
    (writeShellScriptBin "wallnext" ''
      exec qs ipc call wallpaper rotateNow
    '')
    (writeShellScriptBin "wallget" ''
      exec qs ipc call wallpaper get
    '')
    (writeShellScriptBin "wallrotateget" ''
      exec qs ipc call wallpaper getAutorotateEnable
    '')
    (writeShellScriptBin "wallfit" ''
      exec qs ipc call wallpaper setFit "$1"
    '')
    (writeShellScriptBin "wallfitget" ''
      exec qs ipc call wallpaper getFit
    '')
    (writeShellScriptBin "walltransition" ''
      exec qs ipc call wallpaper setTransition "$1"
    '')
    (writeShellScriptBin "walltransitionget" ''
      exec qs ipc call wallpaper getTransition
    '')
    (writeShellScriptBin "wallrotate" ''
      exec qs ipc call wallpaper setAutorotateState "$1"
    '')
    (writeShellScriptBin "wallrotatefolder" ''
      exec qs ipc call wallpaper setAutorotateFolder "$1"
    '')
    (writeShellScriptBin "wallrotatefolderget" ''
      exec qs ipc call wallpaper getAutorotateFolder
    '')
    (writeShellScriptBin "wallrotatefreq" ''
      exec qs ipc call wallpaper setAutorotateFrequency "$1"
    '')
    (writeShellScriptBin "wallrotatefreqget" ''
      exec qs ipc call wallpaper getAutorotateFrequency
    '')

    (writeShellScriptBin "themeset" ''
      exec qs ipc call color setPreset "$1"
    '')
    (writeShellScriptBin "themeget" ''
      exec qs ipc call color getPreset
    '')
    (writeShellScriptBin "themesave" ''
      exec qs ipc call color saveCurrentAsPreset "$1"
    '')
    (writeShellScriptBin "themedynamic" ''
      exec qs ipc call color setPaletteSource dynamic
    '')
    (writeShellScriptBin "themesource" ''
      exec qs ipc call color getPaletteSource
    '')

    (writeShellScriptBin "logout" ''
      if uwsm stop 2>&1 | grep -q "not running"; then
        hyprctl dispatch 'hl.dsp.exit()'
      fi
    '')
  ];
}