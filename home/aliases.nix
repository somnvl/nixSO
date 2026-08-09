{ ... }:
{
  programs.zsh.shellAliases = {
    # SHELL
    ll  = "ls -lah --color=auto";
    gcl = "git clone";

    wifi = "sudo nmtui";
    bluetooth = "sudo bluetui";

    # WORK
    ccc = "cc -Wall -Wextra -Werror";
    vg = "valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes";
    p3 = "python3";
    cx = "chmod +x";
  };

  programs.zsh.initContent = ''
    logout() {
      if uwsm stop 2>&1 | grep -q "not running"; then
        hyprctl dispatch 'hl.dsp.exit()'
      fi
    }
  '';
}