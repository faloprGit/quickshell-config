pragma ComponentBehavior: Bound
import QtQuick
import Qt5Compat.GraphicalEffects
import ".."

Item {
    id: root

    required property var maskItem
    property real gradientAngle: 45.0

    readonly property int normalSpinDuration: 40000

    Component.onCompleted: {
        continuousSpin.startSpin();
    }

    readonly property var activeGradientStops: Gradient {
        GradientStop {
            position: 0.0
            color: Qt.darker(Qt.color(Colors.md3.primary_container), 4.5)
        }
        GradientStop {
            position: 0.5
            color: Qt.color(Colors.md3.background)
        }
        GradientStop {
            position: 1.0
            color: Qt.darker(Qt.color(Colors.md3.tertiary_container), 3.5)
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
        continuousSpin.stop();

        let targetAngle = root.gradientAngle + 120.0 + (Math.random() * 120.0);

        continuousSpin.from = root.gradientAngle;
        continuousSpin.to = targetAngle;
        continuousSpin.duration = 850;
        continuousSpin.easing.type = Easing.OutCubic;
        continuousSpin.isTransitioning = true;
        continuousSpin.start();
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
        id: continuousSpin
        target: root
        property: "gradientAngle"

        property bool isTransitioning: false

        function startSpin() {
            continuousSpin.stop();
            continuousSpin.from = root.gradientAngle;
            continuousSpin.to = root.gradientAngle + 360.0;
            continuousSpin.duration = root.normalSpinDuration;
            continuousSpin.easing.type = Easing.Linear;
            continuousSpin.isTransitioning = false;
            continuousSpin.start();
        }

        onStopped: {
            if (isTransitioning) {
                startSpin();
            } else {
                startSpin();
            }
        }
    }
}
