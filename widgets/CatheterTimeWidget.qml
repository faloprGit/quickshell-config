import QtQuick
import ".."

Item {
    implicitWidth: timeText.implicitWidth
    implicitHeight: timeText.implicitHeight

    PillText {
        id: timeText
        anchors.horizontalCenter: parent.horizontalCenter
        font.pixelSize: 22
        color: Colors.md3.on_tertiary_container
        text: CatheterController.getElapsedTimeString()
    }
}
