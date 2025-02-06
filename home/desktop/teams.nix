{
  pkgs,
  ...
}:
let
  teamsScript = pkgs.writeShellApplication {
    name = "teams";
    runtimeInputs = [ pkgs.chromium ];
    text = ''
      swaymsg exec 'chromium --app=https://teams.microsoft.com/'
    '';
  };
  teamsDeskopItem = pkgs.makeDesktopItem {
    name = "teams";
    exec = "${teamsScript}/bin/teams";
    desktopName = "Microsoft Teams";
    genericName = "Buissness Communication";
    comment = "Microsoft Teams as Chromium web app.";
    startupWMClass = "teams";
    terminal = true;
  };
in
{
  home.packages = [
    teamsDeskopItem
    teamsScript
  ];
}
