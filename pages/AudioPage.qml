import QtQuick
import ".."

Item {
    id: mainPage
    implicitWidth: columnLayout.implicitWidth
    implicitHeight: Metrics.audioPageHeight

    Column {
        id: columnLayout
        anchors.centerIn: parent
        spacing: Metrics.pageRowSpacing

        Row {
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }
}
