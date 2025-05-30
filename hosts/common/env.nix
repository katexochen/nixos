{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    btop
    dig
    gdu
    git
    go
    jq
    killall
    ripgrep
    traceroute
    unzip
    wget
  ];

  programs = {
    starship.enable = true;
  };
}
