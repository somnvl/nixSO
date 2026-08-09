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

        anchors { top: true; bottom: true; left: true; right: true }
        color: "transparent"

        Item {
            id: layers
            anchors.fill: parent

            property bool usingA: true
            property bool animating: false
            property bool needsSwap: false
            property int fillMode: {
                switch (WallpaperService.fitMode) {
                    case "contain": return Image.PreserveAspectFit
                    case "stretch":  return Image.Stretch
                    case "tile":     return Image.Tile
                    default:         return Image.PreserveAspectCrop
                }
            }

            function doSwap() {
                const path = WallpaperService.currentWallpaper
                const src = path !== "" ? "file://" + path : ""
                layers.animating = true
                if (layers.usingA) {
                    layerB.source = src
                } else {
                    layerA.source = src
                }
                layers.usingA = !layers.usingA
            }

            AnimatedImage {
                id: layerA
                anchors.fill: parent
                fillMode: layers.fillMode
                asynchronous: true
                opacity: layers.usingA ? 1 : 0
                visible: opacity > 0

                Behavior on opacity {
                    NumberAnimation {
                        duration: WallpaperService.transitionDuration
                        easing.type: Easing.InOutQuad
                    }
                }

                onOpacityChanged: {
                    if (opacity === 0) {
                        source = ""
                    } else if (opacity === 1) {
                        layers.animating = false
                        if (layers.needsSwap) {
                            layers.needsSwap = false
                            layers.doSwap()
                        }
                    }
                }
            }

            AnimatedImage {
                id: layerB
                anchors.fill: parent
                fillMode: layers.fillMode
                asynchronous: true
                opacity: layers.usingA ? 0 : 1
                visible: opacity > 0

                Behavior on opacity {
                    NumberAnimation {
                        duration: WallpaperService.transitionDuration
                        easing.type: Easing.InOutQuad
                    }
                }

                onOpacityChanged: {
                    if (opacity === 0) {
                        source = ""
                    } else if (opacity === 1) {
                        layers.animating = false
                        if (layers.needsSwap) {
                            layers.needsSwap = false
                            layers.doSwap()
                        }
                    }
                }
            }

            Connections {
                target: WallpaperService
                function onCurrentWallpaperChanged() {
                    if (layers.animating) {
                        layers.needsSwap = true
                    } else {
                        layers.doSwap()
                    }
                }
            }

            Component.onCompleted: {
                layerA.source = WallpaperService.currentWallpaper !== ""
                    ? "file://" + WallpaperService.currentWallpaper
                    : ""
            }
        }
    }
}