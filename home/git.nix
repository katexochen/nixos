{pkgs, ...}: let
  userName = "Paul Meyer";
  userEmail = "49727155+katexochen@users.noreply.github.com";
  #  siginigKeyPath = "/home/katexochen/.ssh/gitsign.pub";
in {
  #  home.file.".ssh/allowed_signers".text = "* ${builtins.readFile siginigKeyPath}";

  home.file.".config/git/hooks/commit-msg" = {
    executable = true;
    text = ''
      #!/usr/bin/env sh
      #
      # An example hook script to check the commit log message.
      # Called by "git commit" with one argument, the name of the file
      # that has the commit message.  The hook should exit with non-zero
      # status after issuing an appropriate message if it wants to stop the
      # commit.  The hook is allowed to edit the commit message file.
      #
      # To enable this hook, rename this file to "commit-msg".

      # Uncomment the below to add a Signed-off-by line to the message.
      # Doing this in a hook is a bad idea in general, but the prepare-commit-msg
      # hook is more suited to it.
      #

      SOB=$(git var GIT_AUTHOR_IDENT | sed -n 's/^\(.*>\).*$/Signed-off-by: \1/p')
      grep -qs "^$SOB" "$1" || echo -e "\n$SOB" >> "$1"

      # This example catches duplicate Signed-off-by lines.

      test "" = "$(grep '^Signed-off-by: ' "$1" |
               sort | uniq -c | sed -e '/^[   ]*1[    ]/d')" || {
              echo >&2 Duplicate Signed-off-by lines.
              exit 1
      }
    '';
  };

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
      core.hooksPath = "~/.config/git/hooks";

      init.defaultBranch = "main";
    };

    aliases = {
      sl = "log --pretty=format:'%Cred%h  %Creset%<(50,trunc)%s %Cgreen%<(12,trunc)%cr %Cblue%an%Creset%C(yellow)%d%Creset' --abbrev-commit";
      b = "rev-parse --abbrev-ref HEAD";
      bs-no-remote = "!git branch --format '%(refname:short) %(upstream)' | awk '{if (!$2) print $1;}'";
      bs-mine = "!git branch --sort=-committerdate --format='%(authorname) %09 %(refname:short)' | grep Paul | cut -f2";
      bs-wip = "log --all --grep='wip' --first-parent --date-order --author='Paul Meyer' --max-count=15 --pretty='format: %d    %cr    %C(bold)%s'";
    };

    # TODO: HM next ver
    # hooks = {
    #   pre-commit = "commit-msg";
    # };

    difftastic.enable = true;
  };
}
