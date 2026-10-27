pragma ComponentBehavior: Bound
import QtQuick
import Qt5Compat.GraphicalEffects
import ".."

Item {
    id: root

    required property var maskItem
    property real gradientAngle: 45.0

    readonly property var activeGradientStops: Gradient {
        GradientStop {
            position: 0.0
            color: Qt.darker(Qt.color(Colors.md3.background), 1.28)
        }
        GradientStop {
            position: 0.5
            color: Qt.color(Colors.md3.background)
        }
        GradientStop {
            position: 1.0
            color: Qt.darker(Qt.color(Colors.md3.background), 0.85)
        }
    }

    readonly property point computedStart: {
        let rad = (root.gradientAngle + 180.0) * Math.PI / 180.0;
        let w = root.maskItem.width > 0 ? root.maskItem.width : 150;
        let h = root.maskItem.height > 0 ? root.maskItem.height : 30;

        let x = (Math.cos(rad) * w) / 2 + (w / 2);
        let y = (Math.sin(rad) * h) / 2 + (h / 2);
        return Qt.point(x, y);
    }

    readonly property point computedEnd: {
        let rad = root.gradientAngle * Math.PI / 180.0;
        let w = root.maskItem.width > 0 ? root.maskItem.width : 150;
        let h = root.maskItem.height > 0 ? root.maskItem.height : 30;

        let x = (Math.cos(rad) * w) / 2 + (w / 2);
        let y = (Math.sin(rad) * h) / 2 + (h / 2);
        return Qt.point(x, y);
    }

    function animateToRandomAngle() {
        let targetAngle = Math.random() * 360.0;
        angleAnimation.from = root.gradientAngle;
        angleAnimation.to = targetAngle;
        angleAnimation.start();
    }

    LinearGradient {
        x: root.maskItem.x
        y: root.maskItem.y
        width: root.maskItem.width
        height: root.maskItem.height

        source: root.maskItem

        start: root.computedStart
        end: root.computedEnd
        gradient: root.activeGradientStops
    }

    NumberAnimation {
        id: angleAnimation
        target: root
        property: "gradientAngle"
        duration: Metrics.animDurationSlow
        easing.type: Easing.OutCubic
    }
}
