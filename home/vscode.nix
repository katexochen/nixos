{pkgs, ...}: {
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions;
      [
        # bbenoist.nix
        # brettm12345.nixfmt-vscode
        # davidanson.vscode-markdownlint
        # github.copilot
        # github.github-vscode-theme
        eamodio.gitlens
        github.vscode-pull-request-github
        golang.go
        hashicorp.terraform
        james-yu.latex-workshop
        jnoortheen.nix-ide
        kamadorueda.alejandra
        ms-vscode.cpptools
        redhat.vscode-yaml
        streetsidesoftware.code-spell-checker
        timonwong.shellcheck
        yzhang.markdown-all-in-one
        zxh404.vscode-proto3
      ]
      ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "theme-bluloco-light";
          publisher = "uloco";
          version = "3.7.2";
          sha256 = "sha256-3Od6NXmu/s6vx4KL0Hcmw/ZZ0eXLIov7Dx//3tHJ6Pw=";
        }
        {
          name = "vscode-emacs-minimum";
          publisher = "jamesyang999";
          version = "1.1.1";
          sha256 = "sha256-qxnAhT2UGTQmPw9XmdBdx0F0NNLAaU1/ES9jiqiRrGI=";
        }
        {
          name = "increment-selection";
          publisher = "albymor";
          version = "0.2.0";
          sha256 = "sha256-iP4c0xLPiTsgD8Q8Kq9jP54HpdnBveKRY31Ro97ROJ8=";
        }
        {
          name = "quicktype";
          publisher = "quicktype";
          version = "12.0.46";
          sha256 = "sha256-NTZ0BujnA+COg5txOLXSZSp8TPD1kZNfZPjnvZUL9lc=";
        }
        {
          name = "copilot";
          publisher = "GitHub";
          version = "1.49.6911";
          sha256 = "sha256-1wuUFvlet+BtXQtTXZbigfqh9hsAA4Yqr0yCA8CVw5o=";
        }
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
      "go.lintFlags" = ["--fast"];
      "go.lintTool" = "golangci-lint";
      "go.testFlags" = ["-count=1" "-race" "-v"];
      "go.testTimeout" = "2m";
      "gopls" = {"formatting.gofumpt" = true;};
      "java.saveActions.organizeImports" = true;
      "javascript.updateImportsOnFileMove.enabled" = "always";
      "latex-workshop.latex.recipe.default" = "lastUsed";
      "latex-workshop.message.update.show" = false;
      "latex-workshop.view.pdf.viewer" = "tab";
      "liveServer.settings.donotShowInfoMsg" = true;
      "liveshare.audio.joinCallBehavior" = "accept";
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
    };
    keybindings = [
      {
        key = "ctrl+0";
        command = "workbench.action.terminal.toggleTerminal";
        when = "terminal.active";
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
