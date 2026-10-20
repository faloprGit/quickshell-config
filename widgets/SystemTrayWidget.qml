import QtQuick
import Quickshell.Services.SystemTray
import ".."

Item {
    implicitWidth: trayRow.width
    implicitHeight: trayRow.height

    Row {
        id: trayRow
        spacing: Metrics.defaultRowSpacing
        anchors.centerIn: parent

        Repeater {
            model: SystemTray.items

            delegate: MouseArea {
                id: trayItemMouseArea
                required property var modelData

                acceptedButtons: Qt.LeftButton | Qt.RightButton
                cursorShape: Config.cursorOnMouseArea

                implicitWidth: implicitHeight
                implicitHeight: Metrics.systemTrayIconSize

                hoverEnabled: true

                Rectangle {
                    anchors.fill: parent
                    color: trayItemMouseArea.containsMouse ? Colors.md3.surface_container : "transparent"
                    radius: height / 2
                    PillIcon {
                        anchors.margins: 2
                        anchors.fill: parent
                        source: trayItemMouseArea.modelData.icon
                    }
                }

                onClicked: modelData.activate()
            }
        }
    }
}
