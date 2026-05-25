{
  config,
  lib,
  pkgs,
  ...
}:

let
  user = config.my.user;
in

{
  config = lib.mkIf (config.my.role == "client") {
    home-manager.users.${user} = {
      programs.bash = {
        enable = true;
        historyControl = [
          "ignoredups"
          "ignorespace"
          "erasedups"
        ];
        historyIgnore = [
          "cd"
          "cd *"
          "exit"
          "ls"
          "ls *"
          "shutdown"
          "reboot"
          "poweroff"
        ];
        shellOptions = [
          "histappend"
          "extglob"
          "globstar"
          "checkjobs"
          "checkwinsize"
        ];
        sessionVariables = {
          EDITOR = "nano";
          MANPAGER = "sh -c 'col -bx | bat -l man -p'";
          MANROFFOPT = "-c";
        };
        initExtra = ''
          bind 'set completion-ignore-case on'
          source <(${lib.getExe pkgs.kubectl} completion bash)
          complete -o default -F __start_kubectl k
        '';
        shellAliases = {
          cat = "${lib.getExe pkgs.bat} -pp";
          k = "${lib.getExe pkgs.kubectl}";
          ls = "${lib.getExe pkgs.eza} --git";
          temp = "cd $(mktemp -d); bash; cd - > /dev/null";
          build2cachix = "${lib.getExe pkgs.jq} -r '.[].outputs | to_entries[].value'";
          sha256result = "find result/ -type f -exec sha256sum {} + |  awk '{print $1}' | sort | sha256sum";
        };
      };
      home.sessionPath = [
        "$HOME/go/bin"
        "$HOME/.cargo/bin"
        "$HOME/bin"
      ];
    };
  };
}
