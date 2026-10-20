import QtQuick
import QtQuick.Controls
import ".."

TextField {
    id: customInputField

    property bool isFocusable: true

    horizontalAlignment: TextInput.AlignHCenter
    verticalAlignment: TextInput.AlignVCenter

    implicitWidth: Metrics.textFieldWidth
    implicitHeight: Metrics.textFieldHeight

    placeholderText: "Hi"
    color: Colors.md3.on_secondary_container

    font {
        pixelSize: 16
        weight: Metrics.defaultTextWeight
    }

    hoverEnabled: true
    onHoveredChanged: {
        if (hovered && isFocusable) {
            customInputField.forceActiveFocus();
            customInputField.selectAll();
            PillController.needFocus = true;
        } else {
            customInputField.focus = false;
            customInputField.deselect();
            PillController.needFocus = false;
        }
    }

    background: Rectangle {
        color: Colors.md3.secondary_container
        radius: Metrics.textFieldRadius

        border.color: customInputField.activeFocus ? Colors.md3.primary : "transparent"
        border.width: customInputField.activeFocus ? 2 : 0
    }
}
