pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Quickshell
import ".."

Item {
    id: root

    property real scaleFactor: 1.0

    readonly property real cellSize: 36 * scaleFactor
    readonly property real cellSpacing: 14 * scaleFactor

    implicitWidth: calendarGrid.implicitWidth
    implicitHeight: mainColumn.implicitHeight

    readonly property var currentDate: new Date()
    readonly property int currentYear: currentDate.getFullYear()
    readonly property int currentMonth: currentDate.getMonth()
    readonly property int todayDate: currentDate.getDate()

    readonly property int totalDaysInMonth: new Date(currentYear, currentMonth + 1, 0).getDate()

    readonly property int startOffsetDays: {
        let firstDay = new Date(currentYear, currentMonth, 1).getDay();
        return firstDay === 0 ? 6 : firstDay - 1;
    }

    ColumnLayout {
        id: mainColumn
        anchors.centerIn: parent
        spacing: root.cellSpacing

        Grid {
            columns: 7
            spacing: root.cellSpacing
            Layout.alignment: Qt.AlignHCenter

            Repeater {
                model: ["M", "T", "W", "T", "F", "S", "S"]

                delegate: Item {
                    required property string modelData

                    width: root.cellSize
                    height: root.cellSize

                    PillText {
                        anchors.centerIn: parent
                        text: parent.modelData
                        pixelSize: 18 * root.scaleFactor
                        font.weight: Font.Bold
                        color: Colors.md3.primary
                    }
                }
            }
        }

        Grid {
            id: calendarGrid
            columns: 7
            spacing: root.cellSpacing
            Layout.alignment: Qt.AlignHCenter

            Repeater {
                model: root.startOffsetDays + root.totalDaysInMonth

                delegate: Item {
                    required property int index

                    readonly property int dayNumber: index - root.startOffsetDays + 1
                    readonly property bool isPadding: index < root.startOffsetDays
                    readonly property bool isToday: !isPadding && (dayNumber === root.todayDate)

                    width: root.cellSize
                    height: root.cellSize

                    Rectangle {
                        anchors.fill: parent
                        radius: width / 2
                        visible: !parent.isPadding
                        color: parent.isToday ? Colors.md3.primary_container : "transparent"
                        border.color: parent.isToday ? Colors.md3.primary : "transparent"
                        border.width: parent.isToday ? Math.max(1, Math.round(root.scaleFactor)) : 0

                        PillText {
                            anchors.centerIn: parent
                            text: parent.parent.isPadding ? "" : String(parent.parent.dayNumber)
                            pixelSize: 15 * root.scaleFactor
                            color: parent.parent.isToday ? Colors.md3.on_primary_container : Colors.md3.on_surface
                        }
                    }
                }
            }
        }
    }
}
