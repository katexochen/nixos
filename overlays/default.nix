_:

{
  modifications = final: prev: {
    # example = prev.example.overrideAttrs (oldAttrs: rec {
    # ...
    # });
    btop = prev.btop.overrideAttrs (oldAttrs: {
      patches = oldAttrs.patches or [ ] ++ [
        (final.fetchpatch {
          url = "https://github.com/aristocratos/btop/commit/30b3868787b7f6c1b83a0e790a5e6ee6c28de28c.patch";
          hash = "sha256-BeZL9aSp1C/nBXWl8of8SaPY2VzAkPiUE2cexsAiFRg=";
        })
      ];
    });
  };

  additions = _final: prev: (import ../packages { pkgs = prev; });
}
