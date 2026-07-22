{ config, lib, ... }:

let
  user = config.my.user;
in

{
  config = lib.mkIf (config.my.role == "client") {
    home-manager.users.${user}.programs.starship = {
      enable = true;
      enableBashIntegration = true;
      settings = {
        golang.symbol = "[󰟓 ](regular)";
        aws.disabled = true;
        azure.disabled = true;
        gcloud.disabled = true;
        opa.disabled = true;

        directory.truncate_to_repo = false;
        directory.truncation_length = 3;
        directory.repo_root_style = "bold blue";
      };
    };
  };
}
