import QtQuick
import "../.."

Item {
    id: root

    implicitWidth: clockWidget.implicitWidth + 64
    implicitHeight: Metrics.compactPageHeight

    ClockWidget {
        id: clockWidget
        anchors.centerIn: parent
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Config.cursorOnMouseArea
        onClicked: PillController.navigateAndExpand("Main")
    }
}
