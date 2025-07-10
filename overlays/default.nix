_:

{
  modifications = _final: _prev: {
    # example = prev.example.overrideAttrs (oldAttrs: rec {
    # ...
    # });
  };

  additions = _final: prev: (import ../packages { pkgs = prev; });
}
