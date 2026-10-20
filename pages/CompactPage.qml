import QtQuick
import ".."

Item {
    id: mainPage

    implicitWidth: Metrics.compactPageWidth
    implicitHeight: Metrics.compactPageHeight

    ClockWidget {
        anchors.centerIn: parent
    }
}
