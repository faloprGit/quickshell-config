import QtQuick
import ".."

Item {
    anchors.horizontalCenter: parent.horizontalCenter
    implicitWidth: mainColumn.implicitWidth
    implicitHeight: mainColumn.implicitHeight

    Column {
        id: mainColumn
        anchors.fill: parent

        PillText {
            id: recommendationText
            anchors.left: parent.left
            font.pixelSize: 18
            color: Colors.md3.on_surface
            text: CatheterController.getPredictionReplacementString()
        }

        PillText {
            id: timeText
            anchors.left: parent.left
            font.pixelSize: 18
            color: Colors.md3.on_surface
            text: "Last Changed on: " + CatheterController.getFormattedDateString()
        }
    }
}
