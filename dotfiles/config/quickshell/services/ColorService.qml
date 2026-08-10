pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    property string cacheHome: Quickshell.env("XDG_CACHE_HOME") || (Quickshell.env("HOME") + "/.cache")
    property string configHome: Quickshell.env("XDG_CONFIG_HOME") || (Quickshell.env("HOME") + "/.config")
    property string dataHome: Quickshell.env("XDG_DATA_HOME") || (Quickshell.env("HOME") + "/.local/share")

    property string paletteSource: "preset"
    property string activePreset: ""

    property bool cacheReady: false

    property alias background: colorsAdapter.background
    property alias foreground: colorsAdapter.foreground
    property alias cursor: colorsAdapter.cursor

    property var colors: ({
        color0: colorsAdapter.color0,   color1: colorsAdapter.color1,
        color2: colorsAdapter.color2,   color3: colorsAdapter.color3,
        color4: colorsAdapter.color4,   color5: colorsAdapter.color5,
        color6: colorsAdapter.color6,   color7: colorsAdapter.color7,
        color8: colorsAdapter.color8,   color9: colorsAdapter.color9,
        color10: colorsAdapter.color10, color11: colorsAdapter.color11,
        color12: colorsAdapter.color12, color13: colorsAdapter.color13,
        color14: colorsAdapter.color14, color15: colorsAdapter.color15,
    })

    readonly property var validPaletteSources: ["preset", "dynamic"]

    FileView {
        id: colorsFile
        path: root.cacheHome + "/wallust/quickshell-colors.json"
        watchChanges: true
        onFileChanged: reload()
        onLoaded: root.cacheReady = true
        printErrors: true

        adapter: JsonAdapter {
            id: colorsAdapter
            property string background: "#CCCCCC"
            property string foreground: "#474747"
            property string cursor:     "#474747"
            property string color0:  "#CCCCCC"
            property string color1:  "#333333"
            property string color2:  "#9A9A9A"
            property string color3:  "#868686"
            property string color4:  "#727272"
            property string color5:  "#AEAEAE"
            property string color6:  "#4A4A4A"
            property string color7:  "#5E5E5E"
            property string color8:  "#5E5E5E"
            property string color9:  "#333333"
            property string color10: "#9A9A9A"
            property string color11: "#868686"
            property string color12: "#727272"
            property string color13: "#AEAEAE"
            property string color14: "#4A4A4A"
            property string color15: "#7C7C7C"
        }
    }

    FileView {
        id: presetFallbackFile
        path: root.configHome + "/wallust/colorschemes/" + (root.activePreset !== "" ? root.activePreset : "e-ink-light") + ".json"
        printErrors: false

        onLoaded: {
            if (root.cacheReady) return
            colorsAdapter.background = adapter.special.background
            colorsAdapter.foreground = adapter.special.foreground
            colorsAdapter.cursor     = adapter.special.cursor
            colorsAdapter.color0  = adapter.colors.color0
            colorsAdapter.color1  = adapter.colors.color1
            colorsAdapter.color2  = adapter.colors.color2
            colorsAdapter.color3  = adapter.colors.color3
            colorsAdapter.color4  = adapter.colors.color4
            colorsAdapter.color5  = adapter.colors.color5
            colorsAdapter.color6  = adapter.colors.color6
            colorsAdapter.color7  = adapter.colors.color7
            colorsAdapter.color8  = adapter.colors.color8
            colorsAdapter.color9  = adapter.colors.color9
            colorsAdapter.color10 = adapter.colors.color10
            colorsAdapter.color11 = adapter.colors.color11
            colorsAdapter.color12 = adapter.colors.color12
            colorsAdapter.color13 = adapter.colors.color13
            colorsAdapter.color14 = adapter.colors.color14
            colorsAdapter.color15 = adapter.colors.color15
        }

        adapter: JsonAdapter {
            property JsonObject special: JsonObject {
                property string background: "#CCCCCC"
                property string foreground: "#474747"
                property string cursor: "#474747"
            }
            property JsonObject colors: JsonObject {
                property string color0:  "#CCCCCC"
                property string color1:  "#333333"
                property string color2:  "#9A9A9A"
                property string color3:  "#868686"
                property string color4:  "#727272"
                property string color5:  "#AEAEAE"
                property string color6:  "#4A4A4A"
                property string color7:  "#5E5E5E"
                property string color8:  "#5E5E5E"
                property string color9:  "#333333"
                property string color10: "#9A9A9A"
                property string color11: "#868686"
                property string color12: "#727272"
                property string color13: "#AEAEAE"
                property string color14: "#4A4A4A"
                property string color15: "#7C7C7C"
            }
        }
    }

    FileView {
        id: defaultsFile
        path: Qt.resolvedUrl("../config-defaults/color.json")
        printErrors: false

        onLoaded: {
            root.paletteSource = adapter.paletteSource
            root.activePreset = adapter.activePreset
        }

        adapter: JsonAdapter {
            property string paletteSource: "preset"
            property string activePreset: ""
        }
    }

    FileView {
        id: stateFile
        path: Quickshell.statePath("color.json")
        watchChanges: true
        printErrors: false

        onLoaded: {
            if (!adapter.initialized) return
            root.paletteSource = adapter.paletteSource
            root.activePreset = adapter.activePreset
        }

        adapter: JsonAdapter {
            property bool initialized: false
            property string paletteSource: "preset"
            property string activePreset: ""
        }
    }

    function syncState() {
        stateFile.adapter.initialized = true
        stateFile.adapter.paletteSource = root.paletteSource
        stateFile.adapter.activePreset = root.activePreset
        stateFile.writeAdapter()
    }

    Process {
        id: wallustProcess
        command: ["true"]
    }

    function applyPreset(name) {
        if (name === "") return
        const officialPath = root.configHome + "/wallust/colorschemes/" + name + ".json"
        const userPath = root.dataHome + "/nixso/user-presets/" + name + ".json"
        wallustProcess.command = ["bash", "-c",
            "f=\"" + officialPath + "\"; [ -f \"$f\" ] || f=\"" + userPath + "\"; wallust cs \"$f\""]
        wallustProcess.running = true
    }

    function applyDynamic() {
        if (WallpaperService.currentWallpaper === "") return
        wallustProcess.command = ["wallust", "run", "-s", WallpaperService.currentWallpaper]
        wallustProcess.running = true
    }

    Connections {
        target: WallpaperService
        function onCurrentWallpaperChanged() {
            if (root.paletteSource === "dynamic") {
                root.applyDynamic()
            }
        }
    }

    function setPreset(name) {
        root.activePreset = name
        root.paletteSource = "preset"
        root.syncState()
        root.applyPreset(name)
    }

    function setPaletteSource(source) {
        if (root.validPaletteSources.indexOf(source) === -1) return
        root.paletteSource = source
        root.syncState()

        if (source === "dynamic") {
            root.applyDynamic()
        } else {
            root.applyPreset(root.activePreset)
        }
    }

    FileView {
        id: presetSaveFile
        printErrors: false

        adapter: JsonAdapter {
            property string wallpaper: "None"
            property string alpha: "100"
            property JsonObject special: JsonObject {
                property string background: "#000000"
                property string foreground: "#000000"
                property string cursor: "#000000"
            }
            property JsonObject colors: JsonObject {
                property string color0:  "#000000"
                property string color1:  "#000000"
                property string color2:  "#000000"
                property string color3:  "#000000"
                property string color4:  "#000000"
                property string color5:  "#000000"
                property string color6:  "#000000"
                property string color7:  "#000000"
                property string color8:  "#000000"
                property string color9:  "#000000"
                property string color10: "#000000"
                property string color11: "#000000"
                property string color12: "#000000"
                property string color13: "#000000"
                property string color14: "#000000"
                property string color15: "#000000"
            }
        }
    }

    Process {
        id: mkdirProcess
        command: ["true"]
        property string pendingName: ""

        onRunningChanged: {
            if (!running && mkdirProcess.pendingName !== "") {
                const name = mkdirProcess.pendingName
                mkdirProcess.pendingName = ""
                root.writePreset(name)
            }
        }
    }

    function saveCurrentAsPreset(name) {
        if (name === "") return
        mkdirProcess.command = ["mkdir", "-p", root.dataHome + "/nixso/user-presets"]
        mkdirProcess.pendingName = name
        mkdirProcess.running = true
    }

    function writePreset(name) {
        presetSaveFile.path = root.dataHome + "/nixso/user-presets/" + name + ".json"
        presetSaveFile.adapter.special.background = colorsAdapter.background
        presetSaveFile.adapter.special.foreground = colorsAdapter.foreground
        presetSaveFile.adapter.special.cursor = colorsAdapter.cursor
        presetSaveFile.adapter.colors.color0  = colorsAdapter.color0
        presetSaveFile.adapter.colors.color1  = colorsAdapter.color1
        presetSaveFile.adapter.colors.color2  = colorsAdapter.color2
        presetSaveFile.adapter.colors.color3  = colorsAdapter.color3
        presetSaveFile.adapter.colors.color4  = colorsAdapter.color4
        presetSaveFile.adapter.colors.color5  = colorsAdapter.color5
        presetSaveFile.adapter.colors.color6  = colorsAdapter.color6
        presetSaveFile.adapter.colors.color7  = colorsAdapter.color7
        presetSaveFile.adapter.colors.color8  = colorsAdapter.color8
        presetSaveFile.adapter.colors.color9  = colorsAdapter.color9
        presetSaveFile.adapter.colors.color10 = colorsAdapter.color10
        presetSaveFile.adapter.colors.color11 = colorsAdapter.color11
        presetSaveFile.adapter.colors.color12 = colorsAdapter.color12
        presetSaveFile.adapter.colors.color13 = colorsAdapter.color13
        presetSaveFile.adapter.colors.color14 = colorsAdapter.color14
        presetSaveFile.adapter.colors.color15 = colorsAdapter.color15
        presetSaveFile.writeAdapter()
    }

    IpcHandler {
        target: "color"
        function setPreset(name: string): void { root.setPreset(name) }
        function getPreset(): string { return root.activePreset }
        function setPaletteSource(source: string): void { root.setPaletteSource(source) }
        function getPaletteSource(): string { return root.paletteSource }
        function saveCurrentAsPreset(name: string): void { root.saveCurrentAsPreset(name) }
    }
}