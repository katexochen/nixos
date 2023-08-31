{ pkgs, ... }: {
  services.xserver = {
    layout = "us-custom,de-custom";
    xkbOptions = "ctrl:nocaps,grp:win_space_toggle";

    # Custom keyboard layout
    #
    # See:
    # https://nixos.org/manual/nixos/stable/#custom-xkb-layouts
    # https://discourse.nixos.org/t/5269
    #
    # On change, run the following and logout:
    # gsettings reset org.gnome.desktop.input-sources xkb-options
    # gsettings reset org.gnome.desktop.input-sources sources
    extraLayouts = {
      us-custom = {
        description = "US custom layout";
        languages = [ "eng" ];
        symbolsFile = pkgs.copyPathToStore ../../symbols/us-custom;
      };
      de-custom = {
        description = "DE custom layout";
        languages = [ "ger" ];
        symbolsFile = pkgs.copyPathToStore ../../symbols/de-custom;
      };
    };
  };

  console.useXkbConfig = true;
}
