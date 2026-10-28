import QtQuick
import Quickshell
import ".."

Item {

    implicitWidth: timeText.implicitWidth
    implicitHeight: timeText.implicitHeight

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
        onDateChanged: clockAnim.restart()
    }

    PillText {
        id: timeText
        text: Qt.formatDateTime(clock.date, "hh:mm")

        transformOrigin: Item.Center

        SequentialAnimation on scale {
            id: clockAnim
            running: false
            NumberAnimation { to: 1.12; duration: 120; easing.type: Easing.OutQuad }
            NumberAnimation { to: 1.00; duration: 200; easing.type: Easing.OutBack }
        }
    }
}
