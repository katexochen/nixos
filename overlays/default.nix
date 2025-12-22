_:

{
  modifications = final: prev: {
    # example = prev.example.overrideAttrs (oldAttrs: rec {
    # ...
    # });
    btop = prev.btop.overrideAttrs (oldAttrs: {
      patches = oldAttrs.patches or [ ] ++ [
        (final.fetchpatch {
          url = "https://github.com/aristocratos/btop/commit/1771182c593debd9c5a65f050ef560bf449aab23.patch";
          hash = "sha256-HepoGCO/Yl2uAfdTdqSWXmdID2zDsLbp+0ujjdk8JUw=";
        })

      ];
    });
  };

  additions = _final: prev: (import ../packages { pkgs = prev; });
}
