_: {
  nixpkgs.overlays = [
    (_final: prev: {

      # Fixes random crashes on wayland by not using NIXOS_OZONE_WL and resulting flags (https://github.com/NixOS/nixpkgs/issues/237978)
      # Source: https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/applications/editors/vscode/generic.nix#L121
      vscode = prev.vscode.overrideAttrs (_oldAttrs: {
        preFixup = ''
          gappsWrapperArgs+=(
            --prefix PATH : ${prev.glib.bin}/bin
          )
        '';
      });

    })
  ];
}
