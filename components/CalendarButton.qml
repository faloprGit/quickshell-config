import QtQuick
import Quickshell
import ".."

PillButton {
    anchors.verticalCenter: parent.verticalCenter
    text: ""
    implicitWidth: Metrics.calendarButtonWidth
    implicitHeight: Metrics.calendarButtonHeight

    PillText {
        anchors.centerIn: parent
        anchors.verticalCenterOffset: parent.implicitHeight * 0.12
        text: Qt.formatDateTime(clock.date, "dd")
        scale: parent.implicitHeight * 0.012
    }

    SystemClock {
        id: clock
        precision: SystemClock.Hours
    }
}
