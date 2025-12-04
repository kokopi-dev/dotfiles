#!/usr/bin/env python3
from pathlib import Path
import sys


class AMDVideo:
    _brightness_filepath: Path = Path("/sys/class/backlight/amdgpu_bl1/brightness")
    _max_brightness_filepath: Path = Path("/sys/class/backlight/amdgpu_bl1/max_brightness")

    brightness: int|None
    max_brightness: int|None
    
    def __init__(self):
        self.brightness = self._get_file_int_value(self._brightness_filepath)
        self.max_brightness = self._get_file_int_value(self._max_brightness_filepath)

    def _get_file_int_value(self, filepath: Path) -> int:
        with filepath.open("r", encoding="utf-8") as f:
            return int(f.read().strip())

    def _update_file_value(self, filepath: Path, value) -> None:
        with filepath.open("w+") as f:
            f.write(str(value))

    def increase_brightness(self, inc_by: int|None = None):
        if not self.max_brightness:
            print(f"error: max_brightness file not found {self._max_brightness_filepath}")
            return
        if not self.brightness:
            print(f"error: brightness file not found {self._brightness_filepath}")
            return

        if not inc_by:
            inc_by = int(self.max_brightness / 15)

        new_val = self.brightness + inc_by
        if new_val > self.max_brightness:
            new_val = self.max_brightness

        self._update_file_value(self._brightness_filepath, new_val)

    def decrease_brightness(self, dec_by: int|None = None):
        if not self.max_brightness:
            return
        if not self.brightness:
            return

        if not dec_by:
            dec_by = int(self.max_brightness / 15)

        new_val = self.brightness - dec_by
        lowest_brightness = int(self.max_brightness * 0.05)
        if new_val < lowest_brightness:
            new_val = lowest_brightness

        self._update_file_value(self._brightness_filepath, new_val)

    def print_status(self):
        brightness = self._get_file_int_value(self._brightness_filepath)
        print(f"brightness: {brightness}")

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("need argument +/-")
        exit(1)
    a = AMDVideo()
    if sys.argv[1] == "+":
        a.increase_brightness()
    if sys.argv[1] == "-":
        a.decrease_brightness()
    if sys.argv[1] == "status":
        a.print_status()

#
# command = ""
#
# result = subprocess.run(command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
