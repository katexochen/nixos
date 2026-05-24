{
  config,
  ...
}:

let
  user = config.my.user;
in

{
  users = {
    mutableUsers = false;
    users.root.hashedPasswordFile = "/persist/secrets/root";
    users.${user} = {
      hashedPasswordFile = "/persist/secrets/${user}";
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "video"
        "audio"
        "networkmanager"
        "lp"
        "scanner"
        "docker"
        "adbusers"
      ];
    };
  };

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    users.${user} =
      { ... }:
      {
        home.stateVersion = "22.05";
        home.enableNixpkgsReleaseCheck = true;

        fonts.fontconfig.enable = true;

        xdg.configFile."nixpkgs/config.nix".text = ''
          {
            allowUnfree = true;
          }
        '';
      };
  };
}
