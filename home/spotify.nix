{
  config,
  pkgs,
  ...
}: let
  spotifyScript = pkgs.writeShellApplication {
    name = "spotify";
    runtimeInputs = [pkgs.chromium];
    text = ''
      swaymsg exec 'chromium --app=https://open.spotify.com/'
    '';
  };
  spotifyDeskopItem = pkgs.makeDesktopItem {
    name = "spotify";
    exec = "${spotifyScript}/bin/spotify";
    desktopName = "Spotify";
    genericName = "Music streaming";
    comment = "Spotify as Chromium web app.";
    startupWMClass = "spotify";
    terminal = true;
  };
in {
  home.packages = [spotifyDeskopItem spotifyScript];
}
