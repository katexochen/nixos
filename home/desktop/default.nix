{ pkgs, ... }: {
  imports = [
    ./chromium.nix
    ./discord.nix
    # ./firefox.nix
    ./spotify.nix
    ./teams.nix
    ./vscode.nix
  ];
}
