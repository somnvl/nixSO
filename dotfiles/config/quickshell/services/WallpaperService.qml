pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    readonly property string fitMode: "cover"
    property string currentWallpaper: ""

    FileView {
        id: stateFile
        path: Quickshell.statePath("wallpaper.json")
        watchChanges: true
        printErrors: false

        onLoaded: {
            root.currentWallpaper = adapter.path
        }

        adapter: JsonAdapter {
            property string path: ""
        }
    }

    function set(path) {
        if (path === "") return
        root.currentWallpaper = path
        stateFile.adapter.path = path
        stateFile.writeAdapter()
    }

    IpcHandler {
        target: "wallpaper"

        function set(path: string): void {
            root.set(path)
        }

        function get(): string {
            return root.currentWallpaper
        }
    }
}