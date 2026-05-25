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
      actionlint
      cargo
      clang-tools
      clippy
      crane
      diffoscope
      dive
      docker
      gcc
      gh
      gnumake
      go
      gopls
      python3
      regovis
      rust-analyzer
      rustc
      rustfmt
      shellcheck
      vbindiff
      xxd
    ];
  };
}
