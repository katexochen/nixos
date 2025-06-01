{
  inputs,
  lib,
  ...
}:

{
  nix = {
    settings = {
      trusted-users = [
        "root"
        "@wheel"
      ];
      experimental-features = [
        "nix-command"
        "flakes"
        "auto-allocate-uids"
      ];
      auto-optimise-store = lib.mkDefault true;
      auto-allocate-uids = lib.mkDefault true;
      warn-dirty = true;
      system-features = [
        "kvm"
        "big-parallel"
      ];
    };

    gc = {
      automatic = true;
      dates = lib.mkDefault "weekly";
      options = lib.mkDefault "--delete-older-than +3";
    };

    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;
    nixPath = [ "nixpkgs=${inputs.nixpkgs.outPath}" ];
    # nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;
  };
}
