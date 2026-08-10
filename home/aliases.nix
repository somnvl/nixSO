{ ... }:
{
  programs.zsh.shellAliases = {
    ll  = "ls -lah --color=auto";       # ll
    gcl = "git clone";                  # gcl https://github.com/user/repo

    wifi      = "sudo nmtui";           # wifi
    bluetooth = "sudo bluetui";         # bluetooth

    ccc = "cc -Wall -Wextra -Werror";                                              # ccc main.c -o main
    vg  = "valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes";  # vg ./main
    p3  = "python3";                    # p3 script.py
    cx  = "chmod +x";                   # cx script.sh
  };}