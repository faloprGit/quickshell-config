pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Hyprland

ShellRoot {
    id: root

    Component.onCompleted: {
        var _audio = AudioController;
        var _info = InfoController;
        var _overlay = OverlayController;
        var _catheter = CatheterController;
        var _timing = TimingController;
        var _compact = CompactController;
        var _pill = PillController;
    }

    Variants {
        model: Quickshell.screens

        delegate: PanelWindow {
            required property var modelData
            screen: modelData
            exclusionMode: ExclusionMode.Ignore
            focusable: PillController.needFocus

            readonly property string currentMonitorName: {
                let monitor = Hyprland.monitorFor(modelData);
                return monitor ? monitor.name : "";
            }

            visible: Config.showOnAllScreens || (currentMonitorName === PillController.startupMouseMonitorName)

            mask: Region {
                item: interactibleContainer
            }

            anchors {
                left: true
                right: true
                top: true
                bottom: true
            }

            color: "transparent"

            // Makes the space above the Bar also hoverable
            Item {
                id: interactibleContainer
                anchors.horizontalCenter: parent.horizontalCenter

                implicitWidth: island.implicitWidth
                implicitHeight: island.implicitHeight + island.anchors.topMargin

                Bar {
                    id: island
                    anchors {
                        horizontalCenter: parent.horizontalCenter
                        top: parent.top
                        topMargin: 8
                    }
                }
            }

            HoverHandler {
                id: hover
                onHoveredChanged: {
                    PillController.setHover(hovered);
                }
            }
        }
    }
}
