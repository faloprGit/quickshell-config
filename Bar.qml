pragma ComponentBehavior: Bound
import QtQuick

Rectangle {
    id: mainBar

    implicitWidth: contentLoader.item.implicitWidth + Metrics.barHorizontalPadding
    implicitHeight: contentLoader.item.implicitHeight + Metrics.barVerticalPadding

    color: Colors.md3.background

    radius: Math.min(Metrics.defaultRadius, (height / 2))

    Loader {
        id: contentLoader
        source: "pages/" + (PillController.shouldExpand || OverlayController.isOverlayActive ? PillController.currentPageName + "Page.qml" : "CompactPage.qml")
        anchors.centerIn: parent
    }

    TapHandler {
        acceptedButtons: Qt.BackButton | Qt.ForwardButton | Qt.MiddleButton

        onTapped: (eventPoint, button) => {
            if (!OverlayController.isOverlayActive) {
                if (button === Qt.BackButton) {
                    PillController.goBackward();
                } else if (button === Qt.ForwardButton) {
                    PillController.goForward();
                }
            }

            if (button === Qt.MiddleButton) {
                if (OverlayController.isOverlayActive) {
                    OverlayController.dismissOverlay();
                } else {
                    PillController.navigateTo("Main");
                }
            }
        }
    }

    Behavior on implicitWidth {
        NumberAnimation {
            duration: 250
            easing.type: Easing.InOutQuad
        }
    }

    Behavior on implicitHeight {
        NumberAnimation {
            duration: 250
            easing.type: Easing.InOutQuad
        }
    }

    Behavior on radius {
        NumberAnimation {
            duration: 250
            easing.type: Easing.InOutQuad
        }
    }
}
