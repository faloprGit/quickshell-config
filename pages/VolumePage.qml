import QtQuick
import QtQuick.Layouts
import ".."

Item {
    id: mainPage
    implicitWidth: rowLayout.implicitWidth
    implicitHeight: Metrics.volumePageHeight

    RowLayout {
        id: rowLayout
        anchors.centerIn: parent
        spacing: Metrics.defaultRowSpacing

        VolumeWidget {}
    }
}
