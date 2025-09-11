# Dotfiles

This is a work in progress, check back for updates. Might look into making a changelog.
Each folder should have a README of some tips.

## Current Machine: Arch
- Shell: bash
    * Prompt: Starship
- WM: bspwm
- Terminal: kitty
    * Font: Fira Code
- Editor: neovim
- Status Bar: polybar
- Compositor: picom
- Menu: rofi
- Theme Stuff: gtk-3.0
    * Theme: Juno Ocean
    * Icons: Infinity Lavender Dark Icons
- File Explorer: thunar-git
- Search: fzf, fd, ripgrep
- Misc: exa, bat
- Lockscreen: i3lock
- Password Manager: pass

## Commands

Wifi:
- `nmtui`

Bluetooth:
- `blueman-manager`

Audio:
- `alsamixer`: terminal control of volume

## Some settings
- Icons
    - `~/.config/gtk-3.0/settings.ini`
    - `/usr/share/icons/*`

## Useful wikis
- NVME storage: https://wiki.archlinux.org/title/Solid_state_drive/NVMe

## USB Auto Mounting

- using packages: udisks2 and udiskie (for automatic mounting)
- unmounting needs manual: udiskie-umount /run/media/$USER/usb_folder_name

## TODO
- Multiple Monitor setup
- Wifi script?
- Auto detect usb mounts
