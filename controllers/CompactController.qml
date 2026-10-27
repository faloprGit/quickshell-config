pragma Singleton
import QtQuick
import Quickshell
import ".."

Singleton {
    id: root

    property var masterOrdering: ["Timer", "Main", "Music"]

    // Comp == Complication
    property var activeComps: ({"Main": true})
    property var hangTimers: ({})

    function notifyState(compKey, isActive, hangMs) {
        var duration = (hangMs !== undefined) ? hangMs : Config.compDefaultHangTime;

        if (isActive) {
            cancelHangTimer(compKey);
            setCompActive(compKey, true);
        } else if (isCompActive(compKey)) {
            startHangTimer(compKey, duration);
        }
    }

    function setCompActive(compKey, active) {
        var copy = Object.assign({}, activeComps);
        copy[compKey] = active;
        activeComps = copy;
    }

    function isCompActive(compKey) {
        return activeComps[compKey] === true;
    }

    function startHangTimer(compKey, durationMs) {
        cancelHangTimer(compKey);

        if (durationMs <= 0) {
            setCompActive(compKey, false);
            return;
        };

        var timer = Qt.createQmlObject(
        'import QtQuick; Timer { interval: ' + durationMs + '; repeat: false }',
        root,
        "HangTimer_" + compKey
        )

        timer.triggered.connect(function() {
            setCompActive(compKey, false);
            delete hangTimers[compKey];
            timer.destroy();
        })

        hangTimers[compKey] = timer;
        timer.start();
    }

    function cancelHangTimer(compKey) {
        if (hangTimers[compKey]) {
            hangTimers[compKey].stop();
            hangTimers[compKey].destroy();
            delete hangTimers[compKey];
        }
    }

    readonly property var activeList: {
        var list = [];
        for (var i = 0; i < masterOrdering.length; i++) {
            var key = masterOrdering[i];
            if (isCompActive(key)) {
                list.push(key);
            }
        }
        return list;
    }
}
