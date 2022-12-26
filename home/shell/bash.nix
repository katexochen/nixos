{pkgs, ...}: {
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
    };
    initExtra = ''
      export PATH=$PATH:$(go env GOPATH)/bin
      export PATH=$PATH:/home/katexochen/bin
    '';
    shellAliases = {
      cat = "${pkgs.bat}/bin/bat -pp";
      k = "${pkgs.kubectl}/bin/kubectl";
      ls = "${pkgs.exa}/bin/exa --git -L 3";
    };
  };
}
