import QtQuick
import ".."

Rectangle {
    id: rectButton

    property alias text: btnText.text
    property alias textWidth: btnText.width
    property alias textHeight: btnText.height
    property alias textColor: btnText.color
    property alias fontWeight: btnText.font.weight

    property bool isStandardSize: true
    property real horizontalPadding: 16
    property real verticalPadding: 8

    // Active/Toggle State
    property bool active: false

    signal clicked

    // Calculate scale factor safely based on height
    readonly property real textScale: (height > 0 ? height : Metrics.buttonHeight) / 25

    // Standard size uses preset metrics; custom size wraps scaled text + padding
    implicitHeight: isStandardSize
        ? Metrics.buttonHeight
        : (btnText.implicitHeight * textScale + verticalPadding * 2)

    implicitWidth: isStandardSize
        ? Metrics.buttonWidth
        : (btnText.implicitWidth * textScale + horizontalPadding * 2)

    radius: Metrics.buttonRadius

    // Dynamic color switching for active toggle state
    color: active
        ? Colors.md3.primary_container
        : (mouseHandler.pressed ? Colors.md3.surface_container_low : Colors.md3.surface_container)

    opacity: mouseHandler.containsMouse ? 1.0 : 0.8

    Text {
        id: btnText
        anchors.centerIn: parent
        text: ""

        font.weight: Metrics.defaultTextWeight
        color: rectButton.active ? Colors.md3.on_primary_container : Colors.md3.on_surface

        transformOrigin: Item.Center
        scale: rectButton.textScale
    }

    MouseArea {
        id: mouseHandler
        anchors.fill: parent
        cursorShape: Config.cursorOnMouseArea
        hoverEnabled: true

        onClicked: rectButton.clicked()
    }
}
