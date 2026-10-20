import QtQuick
import ".."

Item {
    id: mainPage
    implicitWidth: rowLayout.implicitWidth
    implicitHeight: Metrics.timePageHeight

    Row {
        id: rowLayout
        anchors.centerIn: parent
        spacing: Metrics.pageRowSpacing

        CircularClockWidget {}

        Column {
            anchors.verticalCenter: parent.verticalCenter

            TimeDateWidget {}

            CatheterTimeWidget {
                anchors.horizontalCenter: parent.horizontalCenter
                MouseArea {
                    hoverEnabled: true
                    anchors.fill: parent
                    cursorShape: Config.cursorOnMouseArea

                    onClicked: PillController.navigateTo("Catheter")
                }
            }
        }

        TimingWidget {}

        CalendarButton {}
    }
}
