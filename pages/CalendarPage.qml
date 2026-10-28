import QtQuick
import QtQuick.Layouts
import ".."

Item {
    id: root
    implicitWidth: mainColumn.implicitWidth
    implicitHeight: mainColumn.implicitHeight + 16

    ColumnLayout {
        id: mainColumn
        spacing: Metrics.defaultColumnSpacing

        TimeDateWidget {
            Layout.alignment: Qt.AlignHCenter
        }

        Rectangle {
            Layout.alignment: Qt.AlignHCenter
            implicitWidth: Math.floor(root.implicitHeight * 0.8)
            implicitHeight: 3
            radius: height / 2
            color: Colors.md3.outline
            opacity: 0.2
        }

        CalendarWidget {
            Layout.alignment: Qt.AlignHCenter
        }
    }
}
