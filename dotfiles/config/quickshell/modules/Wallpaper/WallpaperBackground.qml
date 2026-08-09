import Quickshell
import Quickshell.Wayland
import QtQuick
import "../../services"

Variants {
    model: Quickshell.screens

    PanelWindow {
        required property var modelData
        screen: modelData

        WlrLayershell.namespace: "quickshell:wallpaper"
        WlrLayershell.layer: WlrLayer.Background
        exclusiveZone: 0

        anchors {
            top: true
            bottom: true
            left: true
            right: true
        }

        color: "transparent"

        Image {
            anchors.fill: parent
            source: WallpaperService.currentWallpaper !== ""
                ? "file://" + WallpaperService.currentWallpaper
                : ""
            fillMode: Image.PreserveAspectCrop
            asynchronous: true
            cache: false
        }
    }
}