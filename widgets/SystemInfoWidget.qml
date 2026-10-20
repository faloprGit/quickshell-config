import QtQuick
import ".."

Item {

    implicitWidth: 150 // Needs to be explicit because diskSpeedFormatted fluctuates and changes the width constantly
    implicitHeight: mainColumn.implicitHeight

    Column {
        id: mainColumn

        spacing: Metrics.defaultColumnSpacing

        PillText {
            text: " " + InfoController.cpuUsagePercent + "%"
        }

        PillText {
            text: " " + InfoController.ramUsagePercent + "%"
        }

        PillText {
            text: " " + InfoController.diskSpeedFormatted
        }

        PillText {
            text: " " + InfoController.cpuTemperature
        }

    }
}
