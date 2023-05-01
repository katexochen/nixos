{pkgs, ...}: {
  home.sessionVariables.NIXOS_OZONE_WL = "1";

  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions;
      [
        # bbenoist.nix
        # brettm12345.nixfmt-vscode
        # davidanson.vscode-markdownlint
        # github.github-vscode-theme
        eamodio.gitlens
        github.vscode-pull-request-github
        golang.go
        hashicorp.terraform
        james-yu.latex-workshop
        jnoortheen.nix-ide
        kamadorueda.alejandra
        ms-vscode.cpptools
        ms-vsliveshare.vsliveshare
        redhat.vscode-yaml
        streetsidesoftware.code-spell-checker
        timonwong.shellcheck
        valentjn.vscode-ltex
        yzhang.markdown-all-in-one
        zxh404.vscode-proto3
      ]
      ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "theme-bluloco-light";
          publisher = "uloco";
          version = "3.7.3";
          sha256 = "1il557x7c51ic9bjq7z431105m582kig9v2vpy3k2z3xhrbb0211";
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
          version = "1.84.51";
          sha256 = "1w6ir3g1fh51k0ysa1kc1y4czij9x0iangfiw50566vnixzm7d96";
        }
        {
          name = "vscode-bazel";
          publisher = "bazelbuild";
          version = "0.7.0";
          sha256 = "05wvih09184bsp4rv2m55z0sasra2qrvch5m3bkbrjq7rcqgibgx";
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
