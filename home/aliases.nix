{ ... }:
{
  programs.zsh.shellAliases = {
    ll  = "ls -lah --color=auto";       # ll
    gcl = "git clone";                  # gcl https://github.com/user/repo

    wifi      = "sudo nmtui";           # wifi
    bluetooth = "sudo bluetui";         # bluetooth

    ccc = "cc -Wall -Wextra -Werror";                                             # ccc main.c -o main
    vg  = "valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes"; # vg ./main
    p3  = "python3";                    # p3 script.py
    cx  = "chmod +x";                   # cx script.sh

    # Generic IPC forwards — every command below is built on these two.
    wall  = "qs ipc call wallpaper";    # wall <method> [args]
    theme = "qs ipc call color";        # theme <method> [args]

    # WALLPAPER
    wallnext            = "wall rotateNow";                  # wallnext
    wallget             = "wall get";                        # wallget
    wallrotateget       = "wall getAutorotateEnable";        # wallrotateget
    wallfit             = "wall setFit";                     # wallfit cover   (cover|contain|stretch|tile)
    wallfitget          = "wall getFit";                     # wallfitget
    walltransition      = "wall setTransition";              # walltransition 1500   (ms)
    walltransitionget   = "wall getTransition";              # walltransitionget
    wallrotate          = "wall setAutorotateState";         # wallrotate on   |   wallrotate off
    wallrotatefolder    = "wall setAutorotateFolder";        # wallrotatefolder ~/Pictures/wallpapers
    wallrotatefolderget = "wall getAutorotateFolder";        # wallrotatefolderget
    wallrotatefreq      = "wall setAutorotateFrequency";     # wallrotatefreq 30   (minutes)
    wallrotatefreqget   = "wall getAutorotateFrequency";     # wallrotatefreqget

    # COLOR / THEME
    themeset            = "theme setPreset";                 # themeset purple-dark
    themeget            = "theme getPreset";                 # themeget
    themesave           = "theme saveCurrentAsPreset";       # themesave sunset-mix
    themedynamic        = "theme setPaletteSource dynamic";  # themedynamic   (extract from current wallpaper)
    themesource         = "theme getPaletteSource";          # themesource   → "preset" | "dynamic"
  };

  # Only bash logic that has no IPC equivalent, or that does pure input
  # normalization (not business logic) before forwarding.
  programs.zsh.initContent = ''
    wallset() {
      qs ipc call wallpaper set "$(realpath "$1")"
    }

    logout() {
      if uwsm stop 2>&1 | grep -q "not running"; then
        hyprctl dispatch 'hl.dsp.exit()'
      fi
    }
  '';
}