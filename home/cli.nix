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
    (writeShellScriptBin "wallget" ''
      exec qs ipc call wallpaper get
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

    (writeShellScriptBin "wallhide" ''
      case "$1" in
        on|off)
          exec qs ipc call wallpaper setHiddenState "$1"
          ;;
        "")
          if [ "$(qs ipc call wallpaper getHidden)" = "true" ]; then
            exec qs ipc call wallpaper setHiddenState off
          else
            exec qs ipc call wallpaper setHiddenState on
          fi
          ;;
        *)
          echo "usage: wallhide [on|off]   (no arg = toggle)" >&2
          exit 1
          ;;
      esac
    '')
    (writeShellScriptBin "wallhideget" ''
      exec qs ipc call wallpaper getHidden
    '')

    (writeShellScriptBin "wallrotate" ''
      case "$1" in
        on|off)
          exec qs ipc call wallpaper setAutorotateState "$1"
          ;;
        "")
          if [ "$(qs ipc call wallpaper getAutorotateEnable)" = "true" ]; then
            exec qs ipc call wallpaper setAutorotateState off
          else
            exec qs ipc call wallpaper setAutorotateState on
          fi
          ;;
        *)
          echo "usage: wallrotate [on|off]   (no arg = toggle)" >&2
          exit 1
          ;;
      esac
    '')
    (writeShellScriptBin "wallrotateget" ''
      exec qs ipc call wallpaper getAutorotateEnable
    '')
    (writeShellScriptBin "wallrotatefolder" ''
      exec qs ipc call wallpaper setAutorotateFolder "$(realpath "$1")"
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
    (writeShellScriptBin "wallnext" ''
      exec qs ipc call wallpaper rotateNow
    '')
    (writeShellScriptBin "wallreset" ''
      exec qs ipc call wallpaper resetToDefaults
    '')

    (writeShellScriptBin "wallhelp" ''
      echo 'wall <method> [args]          raw IPC forward to the wallpaper service'
      echo
      echo 'wallset <path>                set wallpaper (relative paths ok)'
      echo 'wallget                       get current wallpaper path'
      echo 'wallfit <mode>                cover | contain | stretch | tile'
      echo 'wallfitget                    get current fit mode'
      echo 'walltransition <ms>           crossfade duration between wallpapers'
      echo 'walltransitionget             get crossfade duration'
      echo 'wallhide [on|off]             hide/show wallpaper, fades out   (no arg = toggle)'
      echo 'wallhideget                   get hidden state (true/false)'
      echo 'wallrotate [on|off]           enable/disable autorotate   (no arg = toggle)'
      echo 'wallrotateget                 get autorotate state (true/false)'
      echo 'wallrotatefolder <path>       autorotate source folder (relative paths ok)'
      echo 'wallrotatefolderget           get autorotate source folder'
      echo 'wallrotatefreq <minutes>      autorotate interval'
      echo 'wallrotatefreqget             get autorotate interval'
      echo 'wallnext                      rotate to the next wallpaper now'
      echo 'walltheme                     switch to dynamic mode (extract from current wallpaper)'
      echo 'wallreset                     reset wallpaper + fit/transition/hide/autorotate to config defaults'
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
    (writeShellScriptBin "themewall" ''
      exec qs ipc call color setPaletteSource dynamic
    '')
    (writeShellScriptBin "walltheme" ''
      exec qs ipc call color setPaletteSource dynamic
    '')
    (writeShellScriptBin "themesource" ''
      exec qs ipc call color getPaletteSource
    '')

    (writeShellScriptBin "themehelp" ''
      echo 'theme <method> [args]         raw IPC forward to the color service'
      echo
      echo 'themeset <preset>             apply a preset, switches palette source to "preset"'
      echo 'themeget                      get active preset name'
      echo 'themesave <name>              save current colors as a user preset'
      echo 'themewall                     switch to dynamic mode (extract from current wallpaper)'
      echo 'themesource                   get palette source: preset | dynamic'
    '')

    (writeShellScriptBin "post-theme-apply" ''
      was_open="$(hyprctl clients -j | jq -e '[.[] | select(.class=="org.gnome.Nautilus")] | length > 0')"

      pkill -f nautilus || true

      if [ "$was_open" = "true" ]; then
        nautilus &
        disown
      fi

      pkill -SIGUSR1 kitty || true
    '')
  ];
}