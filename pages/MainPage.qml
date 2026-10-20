import QtQuick
import QtQuick.Layouts
import ".."

Item {
    id: mainPage
    implicitWidth: rowLayout.implicitWidth
    implicitHeight: Metrics.mainPageHeight

    RowLayout {
        id: rowLayout
        anchors.centerIn: parent
        spacing: Metrics.pageRowSpacing

        WorkspaceWidget {}

        TimeDateWidget {
            MouseArea {
                hoverEnabled: true
                anchors.fill: parent
                cursorShape: Config.cursorOnMouseArea

                onClicked: PillController.navigateTo("Time")
            }
        }

        SystemTrayWidget {}

        NavigationWidget {}
    }
}
