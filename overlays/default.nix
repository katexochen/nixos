_:

{
  modifications = _final: _prev: {
    # example = prev.example.overrideAttrs (oldAttrs: rec {
    # ...
    # });
  };

  additions = final: _prev: (import ../packages { inherit (final) pkgs; });
}
