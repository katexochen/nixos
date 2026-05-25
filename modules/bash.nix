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
    home-manager.users.${user}.programs.bash = {
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
        export PATH=$PATH:/home/${user}/.cargo/bin
        export PATH=$PATH:/home/${user}/bin
      '';
      shellAliases = {
        cat = "${lib.getExe pkgs.bat} -pp";
        k = "${lib.getExe pkgs.kubectl}";
        ls = "${lib.getExe pkgs.eza} --git -L 3";
        temp = "cd $(mktemp -d); bash; cd - > /dev/null";
        build2cachix = "${lib.getExe pkgs.jq} -r '.[].outputs | to_entries[].value'";
        sha256result = "find result/ -type f -exec sha256sum {} + |  awk '{print $1}' | sort | sha256sum";
      };
    };
  };
}
