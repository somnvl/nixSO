pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    property string cacheHome: Quickshell.env("XDG_CACHE_HOME") || (Quickshell.env("HOME") + "/.cache")

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

    FileView {
        id: colorsFile
        path: root.cacheHome + "/wallust/quickshell-colors.json"
        watchChanges: true
        onFileChanged: reload()
        printErrors: true

        adapter: JsonAdapter {
            id: colorsAdapter
            property string background: "#000000"
            property string foreground: "#ffffff"
            property string cursor:     "#ffffff"
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