{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./shell
    ./sway

    ./chromium.nix
    ./discord.nix
    ./droidcam.nix
    # ./firefox.nix
    ./git.nix
    ./k9s.nix
    ./spotify.nix
    ./teams.nix
    ./vscode.nix
  ];
}
