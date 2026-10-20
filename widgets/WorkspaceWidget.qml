import QtQuick
import Quickshell.Hyprland
import ".."

Item {
    implicitWidth: workspaceRow.width + 20
    implicitHeight: Metrics.workspaceWidgetHeight

    Rectangle {
        anchors.fill: parent
        color: Colors.md3.secondary_container

        radius: height / 2

        Row {
            id: workspaceRow
            spacing: Metrics.defaultRowSpacing
            anchors.centerIn: parent

            Repeater {
                model: 5

                delegate: Rectangle {
                    required property int index
                    property int workspaceId: index + 1
                    property bool isCurrent: Hyprland.focusedWorkspace && Hyprland.focusedWorkspace.id === workspaceId

                    implicitHeight: 8
                    implicitWidth: isCurrent ? height * 3.5 : height

                    radius: height / 2

                    color: isCurrent ? Colors.md3.primary : Colors.md3.outline
                    opacity: isCurrent ? 1.0 : (itemMouseArea.containsMouse ? 1 : 0.8)

                    MouseArea {
                        id: itemMouseArea
                        anchors.fill: parent
                        hoverEnabled: true

                        onClicked: {
                            if (Hyprland.usingLua) {
                                // Hyprland 0.55+ Lua syntax
                                Hyprland.dispatch(`hl.dsp.focus({ workspace = ${parent.workspaceId} })`);
                            } else {
                                // Legacy hyprlang syntax fallback
                                Hyprland.dispatch("workspace " + parent.workspaceId);
                            }
                        }
                    }
                }
            }
        }
    }
}
