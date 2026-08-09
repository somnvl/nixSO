import subprocess
import gi  # type: ignore
from gi.repository import GObject, Nautilus  # type: ignore
gi.require_version('Nautilus', '4.1')


class SetBackgroundExtension(GObject.GObject, Nautilus.MenuProvider):
    def get_file_items(self, files):
        if len(files) != 1 or files[0].is_directory():
            return []
        item = Nautilus.MenuItem(
            name="SetBackground::set",
            label="Set as Wallpaper...",
            tip="Set this image as wallpaper",
        )
        item.connect("activate", self._activate, files[0])
        return [item]

    def _activate(self, menu, file):
        path = file.get_location().get_path()
        subprocess.Popen(["qs", "ipc", "call", "wallpaper", "set", path])
