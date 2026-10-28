import QtQuick
import QtQuick.Layouts
import ".."

Item {
    id: root
    implicitWidth: workspaceWidget.implicitWidth
    implicitHeight: workspaceWidget.implicitHeight

    WorkspaceExpandedWidget {
        id: workspaceWidget
        anchors.centerIn: parent
    }
}
