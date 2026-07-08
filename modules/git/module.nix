{
  config,
  lib,
  pkgs,
  ...
}:

let
  user = config.my.user;
  userName = "Paul Meyer";
  userEmail = "katexochen0@gmail.com";
  tomlFormat = pkgs.formats.toml { };
in

{
  config = lib.mkIf (config.my.role == "client") {
    home-manager.users.${user} = {
      programs.git = {
        enable = true;

        signing.format = null;

        settings = {
          user.name = "${userName}";
          user.email = "${userEmail}";

          diff.algorithm = "histogram"; # smarter than the default 'myers'
          diff.colorMoved = "default"; # highlight moved-vs-added lines distinctly
          diff.renames = true; # detect renames

          # merge.conflictStyle = "zdiff3"; # 3-way markers w/ shared ancestor, not compatible with mergiraf
          rerere.enabled = true; # remember conflict resolutions
          # rerere.autoUpdate = true; # automatically stage rerere resolutions

          fetch.prune = true; # drop refs/remotes/* for deleted upstream branches
          pull.ff = "only";
          push.autoSetupRemote = true;

          rebase.updateRefs = true; # update stacked branches when rebasing
          rebase.autoStash = true;

          branch.sort = "-committerdate"; # most recent branches first
          tag.sort = "version:refname"; # semver-aware: v1.10 > v1.9
          commit.verbose = true; # show diff in the editor when writing the msg
          help.autocorrect = "prompt"; # ask before running 'git stauts' as 'git status'
          init.defaultBranch = "main";

          submodule.recurse = true;
          clone.recurseSubmodules = true;

          # validate object integrity on clone/fetch/push
          transfer.fsckObjects = true;
          fetch.fsckObjects = true;
          receive.fsckObjects = true;

          sendemail = {
            smtpServer = "smtp.gmail.com";
            smtpServerPort = 587;
            smtpUser = userEmail;
            smtpEncryption = "tls";
          };
          credentials.helper = "store";

          alias = {
            sl = "log --pretty=format:'%Cred%h  %Creset%<(70,trunc)%s %Cgreen%<(12,trunc)%cr %Cblue%an%Creset%C(yellow)%d%Creset' --abbrev-commit";
            b = "branch --show-current";
            bs-no-remote = "!git branch --format '%(refname:short) %(upstream)' | awk '{if (!$2) print $1;}'";
            bs-mine = "!git branch --sort=-committerdate --format='%(authorname)%09%(refname:short)' | grep -F '${userName}' | cut -f2";
            bs-wip = "log --all --grep='wip' --first-parent --date-order --author='${userName}' --max-count=15 --pretty='format: %d    %cr    %C(bold)%s'";
            add-fork = "!git remote add \${1%/*} https://github.com/\${1} && git fetch \${1%/*}; #";
            oops = "commit --amend --no-edit";
            rapply = "!curl -fsSL \${1} | git apply -v --index; #";
            hooks-off = "config core.hooksPath /dev/null";
            hooks-on = "config --unset core.hooksPath";
            asq = "!git rebase -i --autosquash HEAD~\${1}; #";
            force = "push --force-with-lease --force-if-includes";
            ghhist = "!git log --no-merges --pretty=format:\"$(git config --get remote.upstream.url || git config --get remote.origin.url)/commit/%h %s\" $1^..$2 ; #";
          };
        };

        hooks = {
          commit-msg = lib.getExe (
            pkgs.writeShellApplication {
              name = "commit-msg-hook";
              runtimeInputs = with pkgs; [
                git
                gnugrep
              ];
              text = builtins.readFile ./commit-msg.sh;
            }
          );
        };
      };

      programs.difftastic.enable = true;
      programs.mergiraf = {
        enable = true;
        enableGitIntegration = true;
      };

      home.packages = [
        pkgs.git-absorb
        pkgs.git-prole
      ];

      # git prole convert                         # existing repo -> .git/ + sibling worktrees
      # git prole clone https://github.com/o/r    # or clone fresh
      # git prole add feat-x                      # from existing branch
      # git prole add -b feat-x                   # create new branch feat-x
      xdg.configFile."git-prole/config.toml".source = tomlFormat.generate "git-prole-config.toml" {
        add.commands = [ "direnv allow" ];
        add.track = false;
      };
    };
  };
}
