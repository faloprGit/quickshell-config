import QtQuick
import QtQuick.Layouts
import "../.."

Item {
    id: root

    implicitWidth: rowLayout.implicitWidth + 8
    implicitHeight: Metrics.compactPageHeight

    readonly property bool isFinished: TimingController.isCountingDown && TimingController.storedTime === 0 && !TimingController.timerRunning

    RowLayout {
        id: rowLayout
        anchors.centerIn: parent
        spacing: 8

        PillText {
            pixelSize: 16
            color: root.isFinished ? Colors.md3.error : Colors.md3.on_tertiary_container
            text: TimingController.isCountingDown ? "" : "󱎫"
            Layout.alignment: Qt.AlignVCenter
        }

        PillText {
            pixelSize: 16
            color: root.isFinished ? Colors.md3.error : Colors.md3.on_tertiary_container
            text: {
                let h = String(TimingController.hours).padStart(2, "0");
                let m = String(TimingController.minutes).padStart(2, "0");
                let s = String(TimingController.seconds).padStart(2, "0");
                return TimingController.hours > "0" ? `${h}:${m}:${s}` : `${m}:${s}`;
            }
            Layout.alignment: Qt.AlignVCenter
        }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Config.cursorOnMouseArea
        onClicked: PillController.navigateAndExpand("Time")
    }
}
