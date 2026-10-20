pragma Singleton
import QtQuick
import Quickshell
import ".."

Singleton {
    id: root

    property int defaultTimeout: 1700
    property int exitTimeout: 200

    property bool isOverlayActive: false

    property bool ready: false

    Timer {
        interval: 300
        running: true
        repeat: false
        onTriggered: root.ready = true
    }

    property Timer autoCloseTimer: Timer {
        interval: root.defaultTimeout
        repeat: false
        running: false
        triggeredOnStart: false

        onTriggered: {
            root.dismissOverlay();
        }
    }

    function triggerOverlay(pageName, customDuration) {
        if (!ready) return;

        if (pageName && PillController.currentPageName !== pageName) {
            PillController.overlayOverridePage = pageName;
        }

        isOverlayActive = true;

        autoCloseTimer.interval = customDuration !== undefined ? customDuration : root.defaultTimeout;

        if (PillController.shouldExpand) {
            autoCloseTimer.stop();
        } else {
            autoCloseTimer.restart();
        }
    }

    function dismissOverlay() {
        if (isOverlayActive) {
            autoCloseTimer.stop();
            root.isOverlayActive = false;
            PillController.overlayOverridePage = "";
        }
    }

    Connections {
        target: PillController

        function onShouldExpandChanged() {
            if (root.isOverlayActive) {
                if (PillController.shouldExpand) {
                    root.autoCloseTimer.stop();
                } else {
                    root.autoCloseTimer.interval = root.exitTimeout;
                    root.autoCloseTimer.restart();
                }
            }
        }
    }
}
