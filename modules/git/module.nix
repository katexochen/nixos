{ config, lib, pkgs, ... }:

let
  user = config.my.user;
  userName = "Paul Meyer";
  userEmail = "katexochen0@gmail.com";
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

          init.defaultBranch = "main";
          push.autoSetupRemote = true;
          pull.ff = "only";
          rebase.autoStash = true;

          sendemail = {
            smtpServer = "smtp.gmail.com";
            smtpServerPort = 587;
            smtpUser = userEmail;
            smtpEncryption = "tls";
          };
          credentials.helper = "store";

          alias = {
            sl = "log --pretty=format:'%Cred%h  %Creset%<(70,trunc)%s %Cgreen%<(12,trunc)%cr %Cblue%an%Creset%C(yellow)%d%Creset' --abbrev-commit";
            b = "rev-parse --abbrev-ref HEAD";
            bs-no-remote = "!git branch --format '%(refname:short) %(upstream)' | awk '{if (!$2) print $1;}'";
            bs-mine = "!git branch --sort=-committerdate --format='%(authorname) %09 %(refname:short)' | grep '${userName}' | cut -f2";
            bs-wip = "log --all --grep='wip' --first-parent --date-order --author='${userName}' --max-count=15 --pretty='format: %d    %cr    %C(bold)%s'";
            add-fork = "!git remote add \${1%/*} https://github.com/\${1} && git fetch \${1%/*}; #";
            oops = "commit --amend --no-edit";
            rapply = "!curl -fsSL \${1} | git apply -v --index; #";
            hooks-off = "config core.hooksPath /dev/null";
            asq = "!git rebase -i --autosquash HEAD~\${1}; #";
            force = "push --force-with-lease";
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
    };
  };
}
