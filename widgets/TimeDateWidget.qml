import QtQuick
import Quickshell
import ".."

Item {

    implicitWidth: mainColumn.implicitWidth
    implicitHeight: mainColumn.implicitHeight

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

    Column {
        id: mainColumn
        anchors.fill: parent
        spacing: -5

        PillText {
            id: timeText
            text: Qt.formatDateTime(clock.date, "hh:mm")

            anchors.horizontalCenter: parent.horizontalCenter
        }

        PillText {
            id: dateText
            text: Qt.formatDateTime(clock.date, "ddd dd MMM")

            anchors.horizontalCenter: parent.horizontalCenter

            font {
                pixelSize: 15
                capitalization: Font.AllUppercase
            }
        }
    }
}
