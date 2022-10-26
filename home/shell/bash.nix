{pkgs, ...}: {
  programs.bash = {
    enable = true;
    historyIgnore = [
      "cd"
      "exit"
      "ls"
      "shutdown"
    ];
    sessionVariables = {
      EDITOR = "nano";
    };
    initExtra = ''
      export PATH=$PATH:$(go env GOPATH)/bin
    '';
    shellAliases = {
      cat = "${pkgs.bat}/bin/bat -pp";
      k = "${pkgs.kubectl}/bin/kubectl";
      ls = "${pkgs.exa}/bin/exa --git -L 3";
    };
  };
}
