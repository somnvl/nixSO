import os
import gi

from gi.repository import GObject, Nautilus

gi.require_version("Nautilus", "4.1")

STATE_FILE = os.path.expanduser("~/.local/state/nixso/nautilus-last-path")


class TrackLastPathExtension(GObject.GObject, Nautilus.MenuProvider):
    def get_background_items(self, current_folder):
        # Called whenever the active folder changes (navigation, tab
        # switch, new window, etc). We're not adding any menu items -
        # this is just used as a hook to record where we are, so a
        # theme-triggered restart can reopen in the same place instead
        # of landing on the starter page.
        #
        # (Nautilus.LocationWidgetProvider would have been the more
        # obvious hook, but it was removed without replacement in the
        # GTK4 port - get_background_items is the documented
        # workaround.)
        try:
            uri = current_folder.get_uri()
            os.makedirs(os.path.dirname(STATE_FILE), exist_ok=True)
            with open(STATE_FILE, "w") as f:
                f.write(uri)
        except (OSError, AttributeError):
            pass
        return []
