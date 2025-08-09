`i3lockscreen@.service` -> /etc/systemd/system/i3lockscreen@.service
`i3-main lock-on-suspend` -> /home/$USER/.local/bin

## Enable
`sudo systemctl enable i3lockscreen@USERNAME.service`
test: `sudo systemctl start i3lockscreen@USERNAME.service`
