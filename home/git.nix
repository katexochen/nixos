{ pkgs, ... }:
let
  userName = "Paul Meyer";
  userEmail = "katexochen0@gmail.com";
  #  siginigKeyPath = "/home/katexochen/.ssh/gitsign.pub";

  commit-msg-hook = pkgs.writeShellApplication {
    name = "commit-msg-hook";
    runtimeInputs = with pkgs; [
      git
      gnugrep
    ];
    text = builtins.readFile ./commit-msg.sh;
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
      pull.ff = "only";
      merge.conflictStyle = "zdiff3";
      rebase.autoStash = true;
      # rerere.enabled = true;
      sendemail = {
        smtpServer = "smtp.gmail.com";
        smtpServerPort = 587;
        smtpUser = userEmail;
        smtpEncryption = "tls";
      };
      credentials.helper = "store";
    };

    aliases = {
      # Print a table like short log.
      sl = "log --pretty=format:'%Cred%h  %Creset%<(50,trunc)%s %Cgreen%<(12,trunc)%cr %Cblue%an%Creset%C(yellow)%d%Creset' --abbrev-commit";
      # Print the name of the current branch.
      b = "rev-parse --abbrev-ref HEAD";
      # List branches without a remote.
      bs-no-remote = "!git branch --format '%(refname:short) %(upstream)' | awk '{if (!$2) print $1;}'";
      # List my branches, sorted by last commit date.
      bs-mine = "!git branch --sort=-committerdate --format='%(authorname) %09 %(refname:short)' | grep '${userName}' | cut -f2";
      # List my branches that contain wip commits.
      bs-wip = "log --all --grep='wip' --first-parent --date-order --author='${userName}' --max-count=15 --pretty='format: %d    %cr    %C(bold)%s'";
      # Add the fork of someone else as a remote.
      add-fork = "!git remote add \${1%/*} https://github.com/\${1} && git fetch \${1%/*}; #"; # $1 is appended to the end, ignoring it with #
      # Add changes to the last commit.
      oops = "commit --amend --no-edit";
      # Apply a patch from remote URL.
      rapply = "!curl -fsSL \${1} | git apply -v --index; #";
      # Deactivate global hooks in the current repository.
      hooks-off = "config core.hooksPath /dev/null";
      # Interactive rebase with autosquash.
      asq = "!git rebase -i --autosquash HEAD~\${1}; #";
      # Force push with lease.
      force = "push --force-with-lease";
      # Show history between two commits, including links to commits on GitHub.
      ghhist = "!git log --no-merges --pretty=format:\"$(git config --get remote.upstream.url | git config --get remote.origin.url)/commit/%h %s\" $1^..$2 ; #";
    };

    hooks = {
      commit-msg = "${commit-msg-hook}/bin/commit-msg-hook";
    };

    difftastic.enable = true;
  };
}
