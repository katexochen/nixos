let
  dellp27L = "Dell Inc. DELL P2720D CBHJK53";
  dellp27R = "Dell Inc. DELL P2720D GN2ZS03";
  dellu27 = "Dell Inc. DELL U2717D J0XYN8AOA5ML";
  dellaw25 = "Dell Inc. AW2521HFA 7CWTL03";
  p14s = "Lenovo Group Limited 0x403A Unknown";
  l14 = "Lenovo Group Limited L15 U133MM45";
in
{
  services.kanshi = {
    enable = true;
    settings = [
      {
        profile.name = "office";
        profile.outputs = [
          {
            criteria = p14s;
            status = "enable";
            position = "0,240";
          }
          {
            criteria = dellp27L;
            status = "enable";
            position = "1920,0";
          }
          {
            criteria = dellp27R;
            status = "enable";
            position = "4480,0";
          }
        ];
      }
      {
        profile.name = "home";
        profile.outputs = [
          {
            criteria = dellu27;
            status = "enable";
            position = "0,0";
          }
          {
            criteria = p14s;
            status = "enable";
            position = "2560,240";
          }
        ];
      }
      {
        profile.name = "undoced";
        profile.outputs = [
          {
            criteria = p14s;
            status = "enable";
            position = "0,0";
          }
        ];
      }
      {
        profile.name = "mobile-external";
        profile.outputs = [
          {
            criteria = l14;
            status = "enable";
            position = "0,0";
          }
          {
            criteria = p14s;
            status = "enable";
            position = "1920,0";
          }
        ];
      }
      {
        profile.name = "gf";
        profile.outputs = [
          {
            criteria = dellaw25;
            status = "enable";
            position = "0,0";
          }
          {
            criteria = p14s;
            status = "enable";
            position = "0,1080";
          }
        ];
      }
    ];
  };
}
