{pkgs, ...}: {
  programs.git = {
    enable = true;
    userName = "katexochen";
    userEmail = "49727155+katexochen@users.noreply.github.com";
    aliases = {
      sl = "log --pretty=format:'%Cred%h  %Creset%<(40)%s %Cgreen%<(12)%cr %Cblue%an%Creset%C(yellow)%d%Creset' --abbrev-commit";
    };
    difftastic.enable = true;
    includes = [
      {
        contents = {
          init.defaultBranch = "main";
        };
      }
    ];
  };
}
