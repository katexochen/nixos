{ pkgs, ... }:
let
  userName = "Paul Meyer";
  userEmail = "49727155+katexochen@users.noreply.github.com";
  #  siginigKeyPath = "/home/katexochen/.ssh/gitsign.pub";

  commit-msg-hook = pkgs.writeShellApplication {
    name = "commit-msg-hook";
    runtimeInputs = with pkgs; [ git gnugrep ];
    text = (builtins.readFile ./commit-msg.sh);
  };
in
{
  #  home.file.".ssh/allowed_signers".text = "* ${builtins.readFile siginigKeyPath}";

  programs.git = {
    enable = true;

    userName = "${userName}";
    userEmail = "${userEmail}";

    #   signing = {
    #    signByDefault = true;
    #   key = "";
    #   };

    extraConfig = {
      #    commit.gpgsign = true;
      #   tag.gpgsign = true;
      #   gpg.format = "ssh";
      #   gpg.ssh.allowedSignersFile = "~/.ssh/allowed_signers";
      #   user.signingkey = "${siginigKeyPath}";

      init.defaultBranch = "main";
      push.autoSetupRemote = true;
    };

    aliases = {
      sl = "log --pretty=format:'%Cred%h  %Creset%<(50,trunc)%s %Cgreen%<(12,trunc)%cr %Cblue%an%Creset%C(yellow)%d%Creset' --abbrev-commit";
      b = "rev-parse --abbrev-ref HEAD";
      bs-no-remote = "!git branch --format '%(refname:short) %(upstream)' | awk '{if (!$2) print $1;}'";
      bs-mine = "!git branch --sort=-committerdate --format='%(authorname) %09 %(refname:short)' | grep Paul | cut -f2";
      bs-wip = "log --all --grep='wip' --first-parent --date-order --author='Paul Meyer' --max-count=15 --pretty='format: %d    %cr    %C(bold)%s'";
      add-fork = "!git remote add \${1%/*} https://github.com/\${1} && git fetch \${1%/*}; #"; # $1 is appended to the end, ignoring it with #
    };

    hooks = {
      commit-msg = "${commit-msg-hook}/bin/commit-msg-hook";
    };

    difftastic.enable = true;
  };
}
