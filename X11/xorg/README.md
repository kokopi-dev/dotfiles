Files:
- `Xresources` -> `~/.Xresources`
- `.xinitrc` -> `~/.xinitrc`
- `.xserverrc` -> `~/.xserverrc`
- `xorg.conf.d/30-touchpad.conf` -> `/etc/X11/xorg.conf.d/30-touchpad.conf`
- `xorg.conf.d/40-libinput.conf` -> `/etc/X11/xorg.conf.d/40-libinput.conf`
- `xorg.conf` -> `/etc/X11/xorg.conf`

---

Xorg conf generation:
https://wiki.archlinux.org/title/xorg : 3.2

---
Test keystrokes with command:
```
xinput list
xinput test <device>
```
