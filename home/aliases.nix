{ ... }:
{
  programs.zsh.shellAliases = {
    logout = "uwsm stop";

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
}