import Quickshell
import Quickshell.Wayland
import Quickshell.Services.UPower
import QtQuick
import QtQuick.Layouts
import "../../services"

Variants {
    model: Quickshell.screens

    PanelWindow {
        required property var modelData
        screen: modelData

        WlrLayershell.namespace: "quickshell:bar"

        surfaceFormat.opaque: false
        color: "transparent"
        exclusiveZone: 0

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
                color: ColorService.foreground
                font.pixelSize: 12
                text: Qt.formatDateTime(new Date(), "HH:mm")

                Timer {
                    id: clockTimer
                    running: true
                    repeat: true
                    triggeredOnStart: true
                    interval: 60000 - (Date.now() % 60000)

                    onTriggered: {
                        clock.text = Qt.formatDateTime(new Date(), "HH:mm")
                        // re-sync so we always fire right at the start of the next minute
                        interval = 60000
                    }
                }
            }

            Item {
                Layout.fillWidth: true
            }

            Text {
                color: ColorService.foreground
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