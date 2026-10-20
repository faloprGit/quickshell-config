// PillText.qml
import QtQuick
import ".."

Item {
    id: root

    property alias text: primaryText.text
    property string sampleText: ""

    property int alignment: Text.AlignHCenter
    property alias font: primaryText.font
    property alias color: primaryText.color
    property alias pixelSize: primaryText.font.pixelSize

    property bool scrollable: false
    property real scrollSpeed: 40
    property int textSpacing: 40

    implicitWidth: sampleText !== "" ? sampleMetrics.width : singleTextMetrics.width
    implicitHeight: singleTextMetrics.height

    clip: true

    TextMetrics {
        id: sampleMetrics
        font: primaryText.font
        text: root.sampleText
    }

    TextMetrics {
        id: singleTextMetrics
        font: primaryText.font
        text: primaryText.text
    }

    readonly property bool isOverflowing: singleTextMetrics.width > root.width

    Item {
        id: textContainer
        x: 0
        height: parent.height
        width: singleTextMetrics.width * 2 + root.textSpacing

        Text {
            id: primaryText
            anchors.verticalCenter: parent.verticalCenter
            color: Colors.md3.on_surface
            font {
                pixelSize: 24
                weight: Metrics.defaultTextWeight
                family: "NotoSans Nerd Font"
            }
            font.features: { "tnum": 1 }
            horizontalAlignment: root.alignment
            verticalAlignment: Text.AlignVCenter

            onTextChanged: {
                scrollAnim.stop();
                textContainer.x = 0;
                if (root.scrollable && root.isOverflowing) {
                    scrollAnim.restart();
                }
            }
        }

        Text {
            id: duplicateText
            text: primaryText.text
            color: primaryText.color
            font: primaryText.font
            visible: root.scrollable && root.isOverflowing
            anchors.verticalCenter: parent.verticalCenter
            x: primaryText.width + root.textSpacing
            horizontalAlignment: primaryText.horizontalAlignment
            verticalAlignment: primaryText.verticalAlignment
        }
    }

    SequentialAnimation {
        id: scrollAnim
        running: root.scrollable && root.isOverflowing
        loops: Animation.Infinite

        //PauseAnimation { duration: 2000 }

        NumberAnimation {
            target: textContainer
            property: "x"
            from: 0
            to: -(singleTextMetrics.width + root.textSpacing)
            duration: Math.max(1000, ((singleTextMetrics.width + root.textSpacing) / root.scrollSpeed) * 1000)
            easing.type: Easing.Linear
        }

        ScriptAction {
            script: textContainer.x = 0
        }
    }
}
