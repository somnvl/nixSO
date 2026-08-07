import Quickshell
import Quickshell.Wayland
import Quickshell.Services.UPower
import QtQuick
import QtQuick.Layouts

ShellRoot {
    Variants {
        model: Quickshell.screens

        PanelWindow {
            required property var modelData
            screen: modelData

            WlrLayershell.namespace: "quickshell"

            surfaceFormat.opaque: false
            color: "transparent"

            anchors {
                top: true
                left: true
                right: true
            }
            implicitHeight: 30

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 12
                anchors.rightMargin: 12
                spacing: 8

                Text {
                    id: clock
                    color: "#c0caf5"
                    font.pixelSize: 12
                    text: Qt.formatDateTime(new Date(), "HH:mm")

                    Timer {
                        interval: 1000
                        running: true
                        repeat: true
                        onTriggered: clock.text = Qt.formatDateTime(new Date(), "HH:mm")
                    }
                }

                Item {
                    Layout.fillWidth: true
                }

                Text {
                    color: "#c0caf5"
                    font.pixelSize: 12
                    text: {
                        const battery = UPower.displayDevice
                        if (!battery || !battery.ready) return "BAT ?"
                        const pct = Math.round(battery.percentage * 100)
                        const charging = battery.state === UPowerDeviceState.Charging
                        return (charging ? "↑ " : "") + pct + "%"
                    }
                }
            }
        }
    }
}