# Neovim Config


# Install
- `git clone ...`

- Install Font (`fonts.zip`)

- Install Snyk server (`./scripts/install-snyk-ls.sh`)

- Change `vars.lua` file

# Requirements
 - ripgrep [telescope search, grep] (`brew install ripgrep`)
 - Font
 - Snyk CLI

# Chat sheet

`:Telescope notiy` - Get last notifications

# Keymaps
`<leader>ff` - Open Telescope

`Ctrl + n` - Toggle File Tree

`:` - Open CMD

## Telescope
`Ctrl + a` - Toggle git stage file 

## File Tree
`r` - Rename

`a` - Add file or dir

`d` - Delete

`m` - Move

`Shift + p` - Preview (toggle)

### Git tab
`ga` - Toggle git stage

`gr` - Revert

`gc` - Commit

`gp` - Push

## Code (Normal Mode)
`F2` - Rename

### Code Navigation
`g(p)d` - Go to (preview) definition

`g(p)D` - Go to (preview) declaration

`g(p)i` - Go to (preview) implementation

`g(p)r` - Go to (preview) references

`Ctrl + k` - Hover signature

`Shift + K` - Hover ?

`gf` - Check code Actions

`gpt` - Open type definition preview

### Actions
`<space>ca` - Code action

`gf` - Select code action (Telescope)

`<space>fo` - Format


### Worspaces

`<space>wa` - Add folder to workspace

`<space>wr` - Remove folder from worspace

`<space>wl` - List ws folder

# Commands
`Telescope` - Open telescope

`GitDiff` - Open diff

`Mason` - Open Mason

`Lazy` - Open Lazy

`Gdiffsplit` - Open diff tool split screen


# Licenses
- Fonts (`fonts.zip`)
``` 
Copyright (c) 2014, The Fira Code Project Authors (https://github.com/tonsky/FiraCode)

This Font Software is licensed under the SIL Open Font License, Version 1.1.
```

- Mason config was copied (under GPL-3.0) from [NvChad](https://github.com/NvChad/NvChad), license is on top of the files
