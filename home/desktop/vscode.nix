{ pkgs, ... }: {
  home.sessionVariables.NIXOS_OZONE_WL = "1";

  programs.vscode = {
    enable = true;
    enableExtensionUpdateCheck = true;
    enableUpdateCheck = false;
    mutableExtensionsDir = false;
    extensions = with pkgs.vscode-extensions; [
      albymor.increment-selection
      bazelbuild.vscode-bazel
      eamodio.gitlens
      github.copilot
      github.copilot-chat
      github.vscode-github-actions
      golang.go
      hashicorp.terraform
      iliazeus.vscode-ansi
      jamesyang999.vscode-emacs-minimum
      jnoortheen.nix-ide
      mkhl.direnv
      ms-python.python
      ms-python.vscode-pylance
      ms-vscode-remote.remote-ssh
      ms-vscode.cpptools
      quicktype.quicktype
      redhat.vscode-yaml
      rust-lang.rust-analyzer
      skellock.just
      streetsidesoftware.code-spell-checker
      tim-koehler.helm-intellisense
      timonwong.shellcheck
      tsandall.opa
      twpayne.vscode-testscript
      uloco.theme-bluloco-light
      yzhang.markdown-all-in-one
      zxh404.vscode-proto3
    ];
    userSettings = {
      "C_Cpp.clang_format_fallbackStyle" = "{ BasedOnStyle: Google, IndentWidth: 4, TabWidth: 4 }";
      "C_Cpp.clang_format_style" = "{ BasedOnStyle: Google, IndentWidth: 4, TabWidth: 4 }";
      "cSpell.allowCompoundWords" = true;
      "diffEditor.ignoreTrimWhitespace" = false;
      "editor.acceptSuggestionOnEnter" = "off";
      "editor.bracketPairColorization.enabled" = false;
      "editor.fontFamily" = "'Droid Sans Mono', 'monospace', monospace, 'Font Awesome 6 Free', 'Font Awesome 6 Brands', 'FiraCode Nerd Font'";
      "editor.formatOnPaste" = true;
      "editor.formatOnSave" = true;
      "editor.inlineSuggest.enabled" = true;
      "editor.multiCursorModifier" = "ctrlCmd";
      "editor.suggest.preview" = true;
      "editor.suggest.shareSuggestSelections" = true;
      "editor.suggestSelection" = "recentlyUsedByPrefix";
      "enableTelemetry" = false;
      "explorer.confirmDragAndDrop" = false;
      "extensions.ignoreRecommendations" = false;
      "files.insertFinalNewline" = true;
      "files.trimFinalNewlines" = true;
      "files.trimTrailingWhitespace" = true;
      "git.autofetch" = true;
      "git.enableSmartCommit" = true;
      "git.mergeEditor" = true;
      "gitlens.codeLens.enabled" = false;
      "gitlens.statusBar.enabled" = false;
      "go.buildTags" = "integration";
      "go.coverageOptions" = "showUncoveredCodeOnly";
      "go.coverOnSingleTest" = true;
      "go.coverOnSingleTestFile" = true;
      "go.lintFlags" = [ "--fast" ];
      "go.lintTool" = "golangci-lint";
      "go.testFlags" = [ "-count=1" "-race" "-v" ];
      "go.testTimeout" = "2m";
      "gopls" = { "formatting.gofumpt" = true; };
      "java.saveActions.organizeImports" = true;
      "javascript.updateImportsOnFileMove.enabled" = "always";
      "latex-workshop.bibtex-fields.sort.enabled" = true;
      "latex-workshop.bibtex-format.sort.enabled" = true;
      "latex-workshop.bibtex-format.trailingComma" = true;
      "latex-workshop.latex.recipe.default" = "lastUsed";
      "latex-workshop.linting.chktex.enabled" = true;
      "latex-workshop.linting.lacheck.enabled" = true;
      "latex-workshop.message.update.show" = false;
      "latex-workshop.view.pdf.viewer" = "tab";
      "liveServer.settings.donotShowInfoMsg" = true;
      "liveshare.audio.joinCallBehavior" = "accept";
      "nix.enableLanguageServer" = true;
      "nix.serverPath" = "${pkgs.nixd}/bin/nixd";
      "nix.serverSettings" = {
        "nixd" = {
          "formatting" = {
            "command" = [ "${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt" ];
          };
        };
      };
      "open-in-browser.default" = "firefox";
      "outline.showFields" = false;
      "python.languageServer" = "Pylance";
      "redhat.telemetry.enabled" = false;
      "terminal.integrated.allowChords" = false;
      "terminal.integrated.scrollback" = 10000;
      "vsintellicode.modify.editor.suggestSelection" = "automaticallyOverrodeDefaultValue";
      "window.menuBarVisibility" = "toggle";
      "workbench.colorTheme" = "Bluloco Light";
      "yaml.completion" = true;
      "yaml.hover" = true;

      "[latex]" = {
        "editor.wordWrap" = "on";
      };

      "[markdown]" = {
        "editor.quickSuggestions" = {
          "other" = true;
          "comments" = true;
          "strings" = true;
        };
      };

      "github.copilot.enable" = {
        "*" = true;
        "yaml" = true;
        "plaintext" = false;
        "markdown" = false;
      };
    };
    keybindings = [
      {
        key = "ctrl+0";
        command = "workbench.action.terminal.toggleTerminal";
        when = "terminal.active";
      }
      {
        key = "ctrl+0";
        command = "workbench.action.focusActiveEditorGroup";
        when = "terminalFocus";
      }
      {
        key = "numpad_add";
        command = "workbench.action.navigateBack";
      }
      {
        key = "numpad_subtract";
        command = "workbench.action.navigateForward";
      }
      {
        key = "ctrl+q";
        command = "workbench.action.closeWindow";
      }
      {
        key = "ctrl+shift+q";
        command = "workbench.action.quit";
      }
    ];
  };
}
