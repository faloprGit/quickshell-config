import QtQuick
import QtQuick.Layouts
import ".."

Item {
    id: compactRoot
    implicitWidth: rowContainer.implicitWidth + 16
    implicitHeight: Metrics.compactPageHeight

    Row {
        id: rowContainer
        anchors.centerIn: parent
        spacing: Metrics.defaultRowSpacing

        Repeater {
            model: CompactController.masterOrdering

            delegate: Item {
                id: delegateItem
                required property string modelData
                required property int index

                readonly property bool active: CompactController.isCompActive(modelData)
                readonly property bool hasActiveBefore: {
                    for (var i = 0; i < delegateItem.index; i++) {
                        if (CompactController.isCompActive(CompactController.masterOrdering[i])) {
                            return true;
                        }
                    }
                    return false;
                }

                height: Metrics.compactPageHeight
                width: active ? rowContent.implicitWidth : 0
                visible: width > 0 || opacity > 0
                opacity: active ? 1.0 : 0.0
                scale: active ? 1.0 : 0.7

                Behavior on implicitWidth {
                    NumberAnimation {
                        duration: Metrics.animDurationNormal
                        easing.type: Metrics.animEasingType
                    }
                }

                Behavior on opacity {
                    NumberAnimation {
                        duration: Metrics.animDurationFast
                    }
                }

                Behavior on scale {
                    NumberAnimation {
                        duration: Metrics.animDurationNormal
                        easing.type: Metrics.animEasingSpring
                    }
                }

                Row {
                    id: rowContent
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: Metrics.defaultRowSpacing

                    Rectangle {
                        visible: delegateItem.active && delegateItem.hasActiveBefore
                        anchors.verticalCenter: parent.verticalCenter
                        implicitWidth: 3
                        implicitHeight: Math.floor(Metrics.compactPageHeight * 0.8)
                        radius: width / 2
                        color: Colors.md3.outline
                        opacity: 0.2
                    }

                    Loader {
                        id: contentLoader
                        anchors.verticalCenter: parent.verticalCenter
                        source: "../widgets/complications/" + delegateItem.modelData + "Complication.qml"
                    }
                }
            }
        }
    }
}
