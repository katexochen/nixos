{ config, lib, pkgs, ... }:

let
  user = config.my.user;
in

{
  config = lib.mkIf (config.my.role == "client") {
    home-manager.users.${user}.home.packages = with pkgs; [
      awscli2
      azure-cli
      azure-storage-azcopy
      (google-cloud-sdk.withExtraComponents [ google-cloud-sdk.components.gke-gcloud-auth-plugin ])
      kubectl
      terraform
    ];
  };
}
