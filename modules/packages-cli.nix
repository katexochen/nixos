{
  config,
  lib,
  pkgs,
  ...
}:

let
  user = config.my.user;
in

{
  config = lib.mkIf (config.my.role == "client") {
    home-manager.users.${user}.home.packages = with pkgs; [
      bat
      btop
      curl
      dust
      eza
      fd
      file
      gdu
      jless
      jq
      magic-wormhole-rs
      ncdu
      oras
      ripgrep
      seashells
      tmux
      unzip
      wget
      yq-go
      zathura
    ];
  };
}
