import QtQuick
import ".."

Item {
    implicitWidth: navigationRow.width
    implicitHeight: navigationRow.height

    Row {
        id: navigationRow
        anchors.verticalCenter: parent.verticalCenter
        spacing: Metrics.defaultRowSpacing

        PillButton {
            text: "♪"
            onClicked: PillController.navigateTo("Music")
        }

        PillButton {
            text: ""
            onClicked: PillController.navigateTo("Info")
        }
    }
}
