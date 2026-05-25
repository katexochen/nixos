{
  config,
  lib,
  pkgs,
  ...
}:

let
  user = config.my.user;
in

{
  config = lib.mkIf (config.my.role == "client") {
    home-manager.users.${user} = {
      home.sessionVariables.NIXOS_OZONE_WL = "1";

      programs.vscode = {
        enable = true;
        mutableExtensionsDir = false;
        profiles.default = {
          enableUpdateCheck = false;
          enableExtensionUpdateCheck = true;
          extensions = with pkgs.vscode-extensions; [
            albymor.increment-selection
            anthropic.claude-code
            eamodio.gitlens
            editorconfig.editorconfig
            github.copilot-chat
            github.vscode-github-actions
            golang.go
            hashicorp.terraform
            iliazeus.vscode-ansi
            jamesyang999.vscode-emacs-minimum
            jnoortheen.nix-ide
            llvm-vs-code-extensions.vscode-clangd
            mkhl.direnv
            # ms-python.python
            ms-python.vscode-pylance
            ms-vscode-remote.remote-ssh
            ms-vscode.cpptools
            ms-vsliveshare.vsliveshare
            nefrob.vscode-just-syntax
            quicktype.quicktype
            redhat.vscode-yaml
            rust-lang.rust-analyzer
            streetsidesoftware.code-spell-checker
            tim-koehler.helm-intellisense
            timonwong.shellcheck
            twpayne.vscode-testscript
            uloco.theme-bluloco-light
            yzhang.markdown-all-in-one
            zxh404.vscode-proto3
          ];
          userSettings = {
            "C_Cpp.intelliSenseEngine" = "disabled";
            "C_Cpp.formatting" = "disabled";
            "C_Cpp.enhancedColorization" = "disabled";
            "C_Cpp.suggestSnippets" = false;
            "clangd.path" = "${pkgs.clang-tools}/bin/clangd";
            "clangd.arguments" = [
              "--background-index"
              "--clang-tidy"
              "--header-insertion=never"
              "--completion-style=detailed"
              "--pch-storage=memory"
            ];
            "cSpell.allowCompoundWords" = true;
            "diffEditor.ignoreTrimWhitespace" = false;
            "editor.acceptSuggestionOnEnter" = "off";
            "editor.bracketPairColorization.enabled" = false;
            "editor.fontFamily" =
              "'Droid Sans Mono', 'monospace', monospace, 'Font Awesome 6 Free', 'Font Awesome 6 Brands', 'FiraCode Nerd Font'";
            "editor.formatOnPaste" = true;
            "editor.formatOnSave" = true;
            "editor.inlineSuggest.enabled" = true;
            "editor.multiCursorModifier" = "ctrlCmd";
            "editor.suggest.preview" = true;
            "editor.suggest.shareSuggestSelections" = true;
            "editor.suggestSelection" = "recentlyUsedByPrefix";
            "telemetry.telemetryLevel" = "error";
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
            "go.testFlags" = [
              "-count=1"
              "-race"
              "-v"
            ];
            "go.testTimeout" = "2m";
            "gopls" = {
              "formatting.gofumpt" = true;
            };
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
            "markdown.extension.tableFormatter.enabled" = false;
            "nix.enableLanguageServer" = true;
            "nix.serverPath" = "${lib.getExe pkgs.nixd}";
            "nix.serverSettings" = {
              "nixd" = {
                "formatting" = {
                  "command" = [ "${lib.getExe pkgs.nixfmt}" ];
                };
              };
            };
            "outline.showFields" = false;
            "python.languageServer" = "Pylance";
            "redhat.telemetry.enabled" = false;
            "terminal.integrated.allowChords" = false;
            "terminal.integrated.scrollback" = 10000;
            "vsintellicode.modify.editor.suggestSelection" = "automaticallyOverrodeDefaultValue";
            "window.menuBarVisibility" = "toggle";
            "window.titleBarStyle" = "native";
            "window.customTitleBarVisibility" = "never";
            "workbench.colorTheme" = "Bluloco Light";
            "workbench.editorAssociations"."git-rebase-todo" = "default";
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
              "plaintext" = false;
              "markdown" = true;
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
              key = "alt+left";
              command = "workbench.action.navigateBack";
            }
            {
              key = "alt+right";
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
            {
              key = "ctrl+alt+2";
              command = "workbench.action.toggleAuxiliaryBar";
            }
          ];
        };
      };
    };
  };
}
