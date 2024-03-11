_: {
  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    settings = {
      golang = {
        symbol = "[  ](regular)";
      };
      aws.disabled = true;
      azure.disabled = true;
      gcloud.disabled = true;
      opa.disabled = true;
    };
  };
}
