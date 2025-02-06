{ pkgs, lib, ... }:
{
  programs.bash = {
    enable = true;
    historyControl = [
      "ignoredups"
      "ignorespace"
      "erasedups"
    ];
    historyIgnore = [
      "cd"
      "exit"
      "ls"
      "shutdown"
      "reboot"
      "poweroff"
    ];
    sessionVariables = {
      EDITOR = "nano";
      MANPAGER = "sh -c 'col -bx | bat -l man -p'";
      MANROFFOPT = "-c";
    };
    initExtra = ''
      export PATH=$PATH:$(go env GOPATH)/bin
      export PATH=$PATH:/home/katexochen/bin
    '';
    shellAliases = {
      cat = "${pkgs.bat}/bin/bat -pp";
      k = "${pkgs.kubectl}/bin/kubectl";
      ls = "${pkgs.eza}/bin/eza --git -L 3";
      temp = "cd $(mktemp -d); bash; cd - > /dev/null";
      # https://docs.cachix.org/pushing#pushing-flake-inputs
      # nix build .#foo --json | build2cachix | cachix push bar
      build2cachix = "${lib.getExe pkgs.jq} -r '.[].outputs | to_entries[].value'";
      sha256result = "find result/ -type f -exec sha256sum {} + |  awk '{print $1}' | sort | sha256sum";
    };
  };
}
