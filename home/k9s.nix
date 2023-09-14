_: {
  programs.k9s = {
    enable = true;
    skin = {
      # https://github.com/derailed/k9s/blob/master/skins/transparent.yml
      # Preserve your terminal session background color
      k9s = {
        body.bgColor = "default";
        promt.bgColor = "default";
        dialog.bgColor = "default";
        frame = {
          crumbs.bgColor = "default";
          title.bgColor = "default";
        };
        views = {
          charts.bgColor = "default";
          table = {
            bgColor = "default";
            header.bgColor = "default";
          };
          xray.bgColor = "default";
          logs = {
            bgColor = "default";
            indicator.bgColor = "default";
          };
        };
      };
    };
  };
}
