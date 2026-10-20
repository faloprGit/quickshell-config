import QtQuick
import Quickshell
import ".."

Item {

    implicitWidth: timeText.implicitWidth
    implicitHeight: timeText.implicitHeight

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

    PillText {
        id: timeText
        text: Qt.formatDateTime(clock.date, "hh:mm")
    }
}
