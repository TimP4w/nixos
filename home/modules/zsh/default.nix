{ pkgs, VARS, ... }:

{
  home.packages = with pkgs; [
    bat
    tldr
    zoxide
  ];

  home.file.".config/oh-my-posh/theme.omp.json" = {
    text = ''
      {
        "$schema": "https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/schema.json",
        "blocks": [
          {
            "alignment": "left",
            "newline": true,
            "segments": [
              {
                "background": "#0c7bbb",
                "foreground": "#ffffff",
                "leading_diamond": "\u256d\u2500\ue0b2",
                "properties": {
                  "alpine": "\uf300",
                  "arch": "\uf303",
                  "centos": "\uf304",
                  "debian": "\uf306",
                  "elementary": "\uf309",
                  "fedora": "\uf30a",
                  "gentoo": "\uf30d",
                  "linux": "\ue712",
                  "macos": "\ue711",
                  "manjaro": "\uf312",
                  "mint": "\uf30f",
                  "opensuse": "\uf314",
                  "raspbian": "\uf315",
                  "ubuntu": "\uf31c",
                  "windows": "\ue70f"
                },
                "style": "diamond",
                "template": " {{ if .WSL }}\ue712 on {{ end }}{{ .Icon }}  ",
                "type": "os"
              },
              {
                "background": "#DA627D",
                "foreground": "#ffffff",
                "powerline_symbol": "\ue0b0",
                "style": "diamond",
                "template": " 🏠 ",
                "type": "text"
              },
              {
                "background": "#8a62da",
                "foreground": "#ffffff",
                "powerline_symbol": "\ue0b0",
                "properties": {
                  "style": "folder"
                },
                "style": "powerline",
                "template": " {{ .Path }} ",
                "type": "path"
              },
              {
                "background": "#191f48",
                "foreground": "#43CCEA",
                "style": "powerline",
                "powerline_symbol": "\ue0b0",
                "foreground_templates": [
                  "{{ if or (.Working.Changed) (.Staging.Changed) }}#FF9248{{ end }}",
                  "{{ if and (gt .Ahead 0) (gt .Behind 0) }}#ff4500{{ end }}",
                  "{{ if gt .Ahead 0 }}#B388FF{{ end }}",
                  "{{ if gt .Behind 0 }}#B388FF{{ end }}"
                ],
                "properties": {
                  "branch_max_length": 25,
                  "fetch_stash_count": true,
                  "fetch_status": true,
                  "fetch_upstream_icon": true
                },
                "template": " {{ .UpstreamIcon }}{{ .HEAD }}{{if .BranchStatus }} {{ .BranchStatus }}{{ end }}{{ if .Working.Changed }} \uf044 {{ .Working.String }}{{ end }}{{ if and (.Working.Changed) (.Staging.Changed) }} |{{ end }}{{ if .Staging.Changed }} \uf046 {{ .Staging.String }}{{ end }}{{ if gt .StashCount 0 }} \ueb4b {{ .StashCount }}{{ end }} ",
                "trailing_diamond": "\ue0b4",
                "type": "git"
              }
            ],
            "type": "prompt"
          },
          {
            "alignment": "right",
            "segments": [
              {
                "foreground": "#81ff91",
                "style": "diamond",
                "template": "<#cc7eda> \u007C </><#7eb8da>RAM:</> {{ (div ((sub .PhysicalTotalMemory .PhysicalFreeMemory)|float64) 1073741824.0) }}/{{ (div .PhysicalTotalMemory 1073741824.0) }}GB",
                "type": "sysinfo"
              },
              {
                "foreground": "#81ff91",
                "properties": {
                  "fetch_version": true
                },
                "style": "powerline",
                "template": "<#cc7eda> \u007C </><#7eb8da>\ue718</> {{ if .PackageManagerIcon }}{{ .PackageManagerIcon }} {{ end }}{{ .Full }}",
                "type": "node"
              },
              {
                "type": "php",
                "style": "powerline",
                "foreground": "#81ff91",
                "template": "<#cc7eda> \u007C </><#7eb8da>\ue73d</> {{ .Full }}"
              },
              {
                "type": "npm",
                "style": "powerline",
                "foreground": "#81ff91",
                "template": "<#cc7eda> \u007C </><#7eb8da>\ue71e </> {{ .Full }}"
              },
              {
                "type": "sysinfo",
                "style": "powerline",
                "foreground": "#81ff91",
                "template": "<> </>"
              },
              {
                "background": "#cecece",
                "foreground": "#4b4b4b",
                "leading_diamond": "\ue0b2",
                "trailing_diamond": "\ue0b0",
                "properties": {
                  "style": "austin",
                  "threshold": 150
                },
                "style": "diamond",
                "template": "⌛  {{ .FormattedMs }} ",
                "type": "executiontime"
              },
              {
                "background": "#cecece",
                "foreground": "#4b4b4b",
                "leading_diamond": "\ue0b2",
                "properties": {
                  "time_format": "15:04:05"
                },
                "style": "diamond",
                "template": "⏰  {{ .CurrentDate | date .Format }} ",
                "trailing_diamond": "\ue0b0",
                "type": "time"
              }
            ],
            "type": "prompt"
          },
          {
            "alignment": "left",
            "newline": true,
            "segments": [
              {
                "foreground": "#0c7bbb",
                "style": "plain",
                "template": "\u2570\u2500",
                "type": "text"
              }
            ],
            "type": "prompt"
          }
        ],
        "final_space": true,
        "version": 2
      }
    '';
  };

  #\uF313

  programs.zsh = {
    enable = true;
    package = pkgs.zsh;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    dotDir = ".config/zsh";

    oh-my-zsh = {
      enable = true;
      package = pkgs.oh-my-zsh;
      theme = "gnzh"; #"af-magic";
      plugins = [
        "sudo"
        "terraform"
        "systemadmin"
        # "vi-mode"
        "git"
        "fzf"
        # "autoenv"
        "direnv"
        "fluxcd"
      ];
    };

    shellAliases = {
      ll = "ls -l";
      nix-rebuild = "$NIXOS_CONFIG_DIR/scripts/rebuild";
      nix-run = "nix-shell --run $SHELL -p";
    };

    initContent = ''
      export NIX_LD=$(nix eval --impure --raw --expr 'let pkgs = import <nixpkgs> {}; NIX_LD = pkgs.lib.fileContents "${pkgs.stdenv.cc}/nix-support/dynamic-linker"; in NIX_LD')
      eval "$(oh-my-posh init zsh --config ~/.config/oh-my-posh/theme.omp.json)"
      eval "$(fzf --zsh)"
      export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always --line-range :500 {}'"
      export FZF_COMPLETION_TRIGGER='**'
      export FZF_DEFAULT_OPTS="
        --color='hl:148,hl+:154,pointer:032,marker:010,bg+:237,gutter:008'
        --prompt='∼ ' --pointer='▶' --marker='✓'
      "   

    '';

    history = {
      size = 10000;
    };
  };
}
