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
            opacity: WallpaperService.hidden ? 0 : 1

            Behavior on opacity {
                NumberAnimation {
                    duration: 250
                    easing.type: Easing.InOutQuad
                }
            }

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

            function isAnimated(src) {
                return src.toLowerCase().endsWith(".gif")
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

            // Static images use a plain Image (decode once, idle after that).
            // GIFs use AnimatedImage (keeps its own frame timer running) -
            // only instantiated when the current source actually needs it,
            // so idle power draw stays at the Image baseline for the common case.
            Loader {
                id: layerA
                anchors.fill: parent
                property string source: ""
                opacity: layers.usingA ? 1 : 0
                visible: opacity > 0
                sourceComponent: layers.isAnimated(source) ? animatedCompA : staticCompA

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

                Component {
                    id: staticCompA
                    Image {
                        anchors.fill: parent
                        fillMode: layers.fillMode
                        asynchronous: true
                        source: layerA.source
                    }
                }

                Component {
                    id: animatedCompA
                    AnimatedImage {
                        anchors.fill: parent
                        fillMode: layers.fillMode
                        asynchronous: true
                        source: layerA.source
                    }
                }
            }

            Loader {
                id: layerB
                anchors.fill: parent
                property string source: ""
                opacity: layers.usingA ? 0 : 1
                visible: opacity > 0
                sourceComponent: layers.isAnimated(source) ? animatedCompB : staticCompB

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

                Component {
                    id: staticCompB
                    Image {
                        anchors.fill: parent
                        fillMode: layers.fillMode
                        asynchronous: true
                        source: layerB.source
                    }
                }

                Component {
                    id: animatedCompB
                    AnimatedImage {
                        anchors.fill: parent
                        fillMode: layers.fillMode
                        asynchronous: true
                        source: layerB.source
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