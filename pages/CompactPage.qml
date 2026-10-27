import QtQuick
import QtQuick.Layouts
import ".."

Item {
    id: compactRoot

    implicitWidth: mainRow.implicitWidth + 16
    implicitHeight: Metrics.compactPageHeight

    RowLayout {
        id: mainRow
        anchors.centerIn: parent
        spacing: Metrics.defaultRowSpacing

        Repeater {
            model: CompactController.activeList

            delegate: RowLayout {
                required property string modelData
                required property int index
                spacing: Metrics.defaultRowSpacing

                Rectangle {
                    visible: parent.index > 0
                    implicitWidth: 3
                    implicitHeight: Math.floor(Metrics.compactPageHeight * 0.8)
                    radius: width / 2
                    color: Colors.md3.outline
                    opacity: 0.2
                    Layout.alignment: Qt.AlignVCenter
                }

                Loader {
                    source: "../widgets/complications/" + parent.modelData + "Complication.qml"
                    Layout.alignment: Qt.AlignVCenter
                }
            }
        }
    }
}
