# dotfiles

Personal configuration files and scripts

## Installation

```powershell
PS > .\Link.ps1
```

```powershell
PS > New-EnvFile
```

## Uninstallation

```powershell
PS > .\Link.ps1 -Unlink $true
```

## cascadia-code

~~https://github.com/microsoft/cascadia-code?tab=readme-ov-file~~

[CaskaydiaMono NF](https://www.nerdfonts.com/font-downloads) for Cascadia without ligatures

## git

```powershell
PS > winget install -i git.git
```

`-i` to enable Windows Terminal integration in interactive mode

## Windows Terminal

## ohmyposh

```powershell
PS > winget install JanDeDobbeleer.OhMyPosh -s winget
```

## Autohotkey

For autostart:

- Copy `.ahk` file
- `Win+R`: `shell:startup`
- Right click, paste as shortcut
