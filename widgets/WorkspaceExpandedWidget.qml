pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import ".."

Item {
    id: root
    implicitWidth: monitorRow.implicitWidth + 24
    implicitHeight: monitorRow.implicitHeight + 16

    RowLayout {
        id: monitorRow
        anchors.centerIn: parent
        spacing: 16

        Repeater {
            model: Quickshell.screens
            delegate: Rectangle {
                id: delegateRect
                required property var modelData

                readonly property var monitor: Hyprland.monitorFor(modelData)
                readonly property bool isFocused: Hyprland.focusedMonitor && monitor && (Hyprland.focusedMonitor.name === monitor.name)
                readonly property int activeWs: monitor && monitor.activeWorkspace ? monitor.activeWorkspace.id : 1

                implicitWidth: 105
                implicitHeight: 72
                radius: 16

                color: isFocused ? Colors.md3.primary_container : Colors.md3.surface_container
                border.color: isFocused ? Colors.md3.primary : Colors.md3.outline_variant
                border.width: isFocused ? 2 : 1
                transformOrigin: Item.Center

                onActiveWsChanged: cardBounce.restart()
                onIsFocusedChanged: if (isFocused) cardBounce.restart()

                Behavior on color {
                    ColorAnimation { duration: Metrics.animDurationFast; easing.type: Easing.OutQuad }
                }
                Behavior on border.color {
                    ColorAnimation { duration: Metrics.animDurationFast; easing.type: Easing.OutQuad }
                }

                Item {
                    anchors.centerIn: parent
                    width: delegateRect.width
                    height: titleLabel.implicitHeight + wsLabel.implicitHeight + 2

                    PillText {
                        id: titleLabel
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: parent.top
                        text: root.getFriendlyName(delegateRect.monitor, delegateRect.modelData.name)
                        pixelSize: 12
                        color: delegateRect.isFocused ? Colors.md3.on_primary_container : Colors.md3.on_surface_variant
                    }

                    PillText {
                        id: wsLabel
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: titleLabel.bottom
                        anchors.topMargin: 2
                        text: "WS " + delegateRect.activeWs
                        pixelSize: 20
                        font.weight: Font.Bold
                        color: delegateRect.isFocused ? Colors.md3.on_primary_container : Colors.md3.on_surface
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Config.cursorOnMouseArea
                    onClicked: {
                        if (delegateRect.monitor) {
                            Hyprland.dispatch("focusmonitor " + delegateRect.monitor.name);
                        }
                    }
                }

                SequentialAnimation on scale {
                    id: cardBounce
                    running: false
                    NumberAnimation { to: 1.06; duration: 100; easing.type: Easing.OutQuad }
                    NumberAnimation { to: 1.00; duration: 180; easing.type: Easing.OutBack }
                }
            }
        }
    }

    function getFriendlyName(monitorObj, fallbackName) {
        if (monitorObj && monitorObj.description && monitorObj.description !== "") {
            let desc = monitorObj.description.trim();
            let firstWord = desc.split(" ");
            if (firstWord && firstWord.length > 0) {
                return firstWord[0];
            }
        }

        if (!fallbackName) return "Display";
        if (fallbackName.includes("DP-")) return "DP " + fallbackName.replace("DP-", "");
        if (fallbackName.includes("HDMI-A-")) return "HDMI " + fallbackName.replace("HDMI-A-", "");
        return fallbackName;
    }
}
