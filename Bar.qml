pragma ComponentBehavior: Bound
import QtQuick
import "."

Item {
    id: mainBarContainer

    implicitWidth: mainBarMask.implicitWidth
    implicitHeight: mainBarMask.implicitHeight

    Rectangle {
        id: mainBarMask

        anchors.fill: parent
        clip: true
        visible: false

        readonly property string targetPage: "pages/" + (PillController.shouldExpand || OverlayController.isOverlayActive ? PillController.currentPageName + "Page.qml" : "CompactPage.qml")

        implicitWidth: (pageLoader.status === Loader.Ready && pageLoader.item ? pageLoader.item.implicitWidth : 150) + Metrics.barHorizontalPadding
        implicitHeight: (pageLoader.status === Loader.Ready && pageLoader.item ? pageLoader.item.implicitHeight : 30) + Metrics.barVerticalPadding

        color: Colors.md3.background
        radius: Math.min(Metrics.defaultRadius, (height / 2))

        Behavior on implicitWidth { Animations.BouncySlide {} }
        Behavior on implicitHeight { Animations.BouncySlide {} }
        Behavior on radius { Animations.BouncySlide {} }
    }

    GradientBackground {
        id: premiumBackground
        maskItem: mainBarMask
    }

    Loader {
        id: pageLoader
        anchors.centerIn: parent
        source: mainBarMask.targetPage
        opacity: 1.0
        scale: 1.0

        Behavior on opacity {
            NumberAnimation { duration: Metrics.animDurationFast; easing.type: Easing.OutQuad }
        }
        Behavior on scale {
            NumberAnimation { duration: Metrics.animDurationNormal; easing.type: Metrics.animEasingType }
        }
    }

    Connections {
        target: mainBarMask
        function onTargetPageChanged() {
            pageTransitionAnim.restart();
            premiumBackground.animateToRandomAngle();
        }
    }

    SequentialAnimation {
        id: pageTransitionAnim

        ParallelAnimation {
            NumberAnimation { target: pageLoader; property: "opacity"; to: 0.0; duration: Metrics.animDurationFast; easing.type: Easing.InQuad }
            NumberAnimation { target: pageLoader; property: "scale"; to: 0.88; duration: Metrics.animDurationFast; easing.type: Easing.InQuad }
        }

        ScriptAction {
            script: {
                pageLoader.source = mainBarMask.targetPage;
            }
        }

        ParallelAnimation {
            NumberAnimation { target: pageLoader; property: "opacity"; to: 1.0; duration: Metrics.animDurationNormal; easing.type: Easing.OutQuad }
            NumberAnimation { target: pageLoader; property: "scale"; to: 1.0; duration: Metrics.animDurationSlow; easing.type: Easing.OutBack }
        }
    }

    TapHandler {
        acceptedButtons: Qt.BackButton | Qt.ForwardButton | Qt.MiddleButton
        onTapped: (eventPoint, button) => {
            if (!OverlayController.isOverlayActive) {
                if (button === Qt.BackButton) PillController.goBackward();
                else if (button === Qt.ForwardButton) PillController.goForward();
            }
            if (button === Qt.MiddleButton) {
                if (OverlayController.isOverlayActive) OverlayController.dismissOverlay();
                else PillController.navigateTo("Main");
            }
        }
    }
}
