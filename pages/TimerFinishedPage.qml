import QtQuick
import QtQuick.Layouts
import ".."

Item {
    id: root
    implicitWidth: rowLayout.implicitWidth + 32
    implicitHeight: Metrics.compactPageHeight

    RowLayout {
        id: rowLayout
        anchors.centerIn: parent
        spacing: Metrics.defaultRowSpacing

        PillText {
            pixelSize: 16
            color: Colors.md3.error
            text: "󱎫"
            Layout.alignment: Qt.AlignVCenter
        }

        PillText {
            pixelSize: 16
            color: Colors.md3.on_surface
            text: "Timer Finished!"
            Layout.alignment: Qt.AlignVCenter
        }
    }
}
