import QtQuick
import Quickshell
import ".."

Item {
    implicitWidth: implicitHeight
    implicitHeight: Metrics.circleClockSize

    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }

    Rectangle {
        anchors.fill: parent
        radius: height / 2
        color: Colors.md3.secondary_container
        border.color: Colors.md3.outline
        border.width: Math.max(1, parent.width / 40)
    }

    Rectangle {
        id: secondHand

        width: parent.width * 0.44
        height: parent.height * 0.045
        radius: height / 2

        color: Colors.md3.primary

        x: (parent.width / 2) - rotationSecondTransform.origin.x
        y: (parent.height / 2) - rotationSecondTransform.origin.y

        transform: Rotation {
            id: rotationSecondTransform

            origin.x: secondHand.height / 2
            origin.y: secondHand.height / 2

            angle: clock.date.getSeconds() * 6 - 90
        }
    }

    Rectangle {
        id: minuteHand

        width: parent.width * 0.38
        height: parent.height * 0.075
        radius: height / 2

        color: Colors.md3.on_secondary_container
        border.color: Colors.md3.secondary_container
        border.width: Math.max(1, parent.width * 0.01)

        x: (parent.width / 2) - rotationMinuteTransform.origin.x
        y: (parent.height / 2) - rotationMinuteTransform.origin.y

        transform: Rotation {
            id: rotationMinuteTransform

            origin.x: minuteHand.height / 2
            origin.y: minuteHand.height / 2

            angle: clock.date.getMinutes() * 6 - 90
        }
    }

    Rectangle {
        id: hourHand

        width: parent.width * 0.28
        height: parent.height * 0.12
        radius: height / 2

        color: Colors.md3.on_secondary_container
        border.color: Colors.md3.secondary_container
        border.width: Math.max(1, parent.width * 0.015)

        x: (parent.width / 2) - rotationHourTransform.origin.x
        y: (parent.height / 2) - rotationHourTransform.origin.y

        transform: Rotation {
            id: rotationHourTransform

            origin.x: hourHand.height / 2
            origin.y: hourHand.height / 2

            angle: (clock.date.getHours() % 12) * 30 + (clock.date.getMinutes() / 2) - 90
        }
    }

    // CenterPin
    Rectangle {
        width: height
        height: parent.height * 0.12
        anchors.centerIn: parent
        radius: height / 2
        color: Colors.md3.primary
        border.color: Colors.md3.secondary_container
        border.width: Math.max(1, parent.width * 0.015)
    }
}
