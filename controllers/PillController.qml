pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Hyprland

Singleton {
    id: root

    property bool isExpanded: false
    readonly property bool shouldExpand: isExpanded || overlayOverridePage !== ""

    property bool isStowed: false
    property bool isShortcutPeeking: false

    property bool needFocus: false
    property var historyStack: ["Main"]
    property int historyIndex: 0

    property string overlayOverridePage: ""
    property string startupMouseMonitorName: ""

    readonly property string currentPageName: overlayOverridePage !== ""
        ? overlayOverridePage
        : historyStack[historyIndex] !== undefined ? historyStack[historyIndex] : "Main"

    readonly property int maxHistoryLength: 20

    function expand() {
        isStowed = false;
        isShortcutPeeking = false;
        isExpanded = true;
    }

    function collapse() {
        isExpanded = false;
        isShortcutPeeking = false;
    }

    function toggleExpand() {
        if (!isExpanded) {
            isStowed = false;
            isShortcutPeeking = false;
        }
        isExpanded = !isExpanded;
    }

    function navigateAndExpand(pageName) {
        isStowed = false;
        isShortcutPeeking = false;
        if (pageName && pageName !== "") {
            navigateTo(pageName);
        }
        isExpanded = true;
    }

    function navigateTo(pageName) {
        if (!pageName || pageName === "") return;
        if (currentPageName === pageName) return; // No Duplicates

        var newStack = historyStack.slice(0, historyIndex + 1);
        newStack.push(pageName);

        if (newStack.length > maxHistoryLength) {
            newStack.shift();
        }

        historyStack = newStack;

        historyIndex = historyStack.length - 1;
    }

    function goBackward() {
        if (historyIndex > 0) {
            historyIndex--;
        }
    }

    function goForward() {
        if (historyIndex < historyStack.length - 1) {
            historyIndex++;
        }
    }

    function toggleStowed() {
        if (isExpanded) {
            collapse();
        }
        isShortcutPeeking = false;
        isStowed = !isStowed
    }

    function toggleShortcutPeek() {
        if (isExpanded) {
            collapse();
        }
        isShortcutPeeking = !isShortcutPeeking;
    }

    Timer {
        id: lockTimer
        interval: 50
        running: true
        repeat: false
        onTriggered: {
            let focused = Hyprland.focusedMonitor;
            if (focused) root.startupMouseMonitorName = focused.name;
        }
    }

}
