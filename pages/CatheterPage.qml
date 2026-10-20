import QtQuick
import ".."

Item {
    id: mainPage
    implicitWidth: rowLayout.implicitWidth
    implicitHeight: Metrics.catheterPageHeight

    Row {
        id: rowLayout
        anchors.centerIn: parent
        spacing: Metrics.pageRowSpacing

        Column {
            anchors.verticalCenter: parent.verticalCenter
            spacing: height / 20

            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: width / 8

                CatheterTimeWidget {
                    anchors.bottom: parent.bottom
                }

                PillButton {
                    anchors.verticalCenter: parent.verticalCenter
                    text: "New"
                    implicitWidth: textWidth * 2

                    onClicked: CatheterController.setCurrentTime()
                }
            }

            CatheterChangedWidget {}
        }
    }
}
