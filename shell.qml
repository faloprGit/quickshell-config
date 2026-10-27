pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland

ShellRoot {
    id: root

    Component.onCompleted: {
        var _audio = AudioController;
        var _music = MusicController;
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
            id: panelWindow
            required property var modelData
            screen: modelData
            exclusionMode: ExclusionMode.Ignore
            focusable: PillController.needFocus

            readonly property string currentMonitorName: {
                let monitor = Hyprland.monitorFor(modelData);
                return monitor ? monitor.name : "";
            }

            visible: Config.showOnAllScreens || (currentMonitorName === PillController.startupMouseMonitorName)

            WlrLayershell.layer: (PillController.isShortcutPeeking || PillController.isExpanded) ? WlrLayer.Overlay : WlrLayer.Top

            mask: PillController.isExpanded ? null : barRegion

            Region {
                id: barRegion
                item: interactibleContainer
            }

            anchors {
                left: true
                right: true
                top: true
                bottom: true
            }

            color: "transparent"

            TapHandler {
                enabled: PillController.isExpanded
                onTapped: (eventPoint) => {
                    let localPos = interactibleContainer.mapFromItem(null, eventPoint.position);
                    if (!interactibleContainer.contains(localPos)) {
                        PillController.collapse();
                    }
                }
            }

            // Makes the space above the Bar also hoverable
            Item {
                id: interactibleContainer
                anchors.horizontalCenter: parent.horizontalCenter

                width: implicitWidth
                height: implicitHeight

                implicitWidth: island.implicitWidth
                implicitHeight: island.implicitHeight + island.anchors.topMargin

                readonly property bool isPeeking: (PillController.isStowed && peekHoverHandler.hovered) || PillController.isShortcutPeeking
                readonly property real targetY: {
                    if (!PillController.isStowed || isPeeking) return 0;
                    return -(island.height + island.anchors.topMargin - 8);
                }

                transform: Translate {
                    id: containerTranslate
                    y: interactibleContainer.targetY

                    Behavior on y {
                        NumberAnimation {
                            duration: Metrics.animDurationNormal
                            easing.type: Easing.OutCubic
                        }
                    }
                }

                HoverHandler {
                    id: peekHoverHandler
                    onHoveredChanged: {
                        OverlayController.setHovered(hovered);
                    }
                }

                TapHandler {
                    acceptedButtons: Qt.LeftButton
                    onTapped: {
                        if (PillController.isStowed) {
                            PillController.isStowed = false;
                        } else if (!PillController.isExpanded) {
                            PillController.expand();
                        }
                    }
                }

                TapHandler {
                    acceptedButtons: Qt.RightButton
                    onTapped: PillController.toggleStowed()
                }

                Bar {
                    id: island
                    anchors {
                        horizontalCenter: parent.horizontalCenter
                        top: parent.top
                        topMargin: 8
                    }
                }
            }
        }
    }

    GlobalShortcut {
        name: "peekTime"
        description: "Toggle Compact Bar Peek"
        onPressed: {
            PillController.toggleShortcutPeek();
        }
    }
}
