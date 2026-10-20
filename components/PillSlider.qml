import QtQuick
import QtQuick.Controls
import ".."

Item {
    id: root

    property real sliderLength: 100
    property real sliderSide: 8
    property bool isVertical: false
    property bool enableScroll: true
    property real scrollStep: 0.01

    property alias value: control.value
    property alias stepSize: control.stepSize
    property alias from: control.from
    property alias to: control.to
    property alias sliderWidth: bg.implicitWidth
    property alias sliderHeight: bg.implicitHeight

    // Expose pressed state
    readonly property bool pressed: control.pressed

    property int orientation: isVertical ? Qt.Vertical : Qt.Horizontal

    signal moved()
    signal released()

    implicitWidth: (isVertical ? Metrics.buttonHeight : sliderLength) || 0
    implicitHeight: (isVertical ? sliderLength : Metrics.buttonHeight) || 0

    Slider {
        id: control

        width: root.isVertical ? root.sliderLength : parent.width
        height: root.isVertical ? root.sliderLength : parent.height
        anchors.centerIn: parent

        value: 0.5
        stepSize: 0.01
        from: 0
        to: 1

        orientation: Qt.Horizontal
        snapMode: Slider.SnapOnRelease

        onMoved: root.moved()
        onPressedChanged: {
            if (!pressed) {
                root.released();
            }
        }

        transform: Rotation {
            angle: root.isVertical ? 270 : 0
            origin.x: control.width / 2
            origin.y: control.height / 2
        }

        background: Rectangle {
            id: bg
            implicitWidth: root.sliderLength
            implicitHeight: root.sliderSide

            x: control.leftPadding
            y: control.topPadding + control.availableHeight / 2 - height / 2
            width: control.availableWidth
            height: root.sliderSide
            radius: height / 2
            color: Colors.md3.on_primary

            Rectangle {
                width: control.visualPosition * parent.width
                height: parent.height
                color: Colors.md3.primary
                radius: height / 2
            }
        }

        handle: Rectangle {
            x: control.leftPadding + control.visualPosition * (control.availableWidth - width)
            y: control.topPadding + control.availableHeight / 2 - height / 2
            implicitWidth: 26
            implicitHeight: 26
            radius: height / 2
            color: control.pressed ? "#f0f0f0" : "#f6f6f6"
            border.color: "#bdbebf"
        }

        MouseArea {
            id: mouseHandler
            anchors.fill: parent
            enabled: root.enableScroll
            propagateComposedEvents: true

            onWheel: (wheel) => {
                const direction = wheel.angleDelta.y > 0 ? 1 : -1;
                const step = root.scrollStep ?? 0.05;
                const newValue = Math.max(control.from, Math.min(control.to, control.value + (direction * step)));

                if (newValue !== control.value) {
                    control.value = newValue;
                    root.moved();
                    root.released();
                }
                wheel.accepted = true;
            }
            onPressed: (mouse) => mouse.accepted = false
        }
    }
}
