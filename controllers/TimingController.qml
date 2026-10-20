pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    property int storedTimeInitial: 1200
    property int storedTime: storedTimeInitial
    property int seconds: storedTime % 60
    property int minutes: Math.floor(storedTime / 60) % 60
    property int hours: Math.floor(storedTime / 3600)

    property bool isCountingDown: true
    property bool isFieldFocusable: true

    Process {
        id: notifyStoppedProc
        command: ["notify-send", "-e", "Timer", "finished", "-a", "SwayNC"]
    }

    Timer {
        id: countTimer
        interval: 1000
        repeat: true
        running: false
        triggeredOnStart: false

        onTriggered: {
            if (parent.isCountingDown) {
                parent.storedTime -= 1;

                if (parent.storedTime <= 0) {
                    parent.timerStop()
                    parent.storedTime = 0
                    notifyStoppedProc.startDetached()
                }
            } else {
                parent.storedTime += 1;
            }
            parent.propagateFromTime();
        }
    }

    function propagateFromTime() {
        seconds = storedTime % 60;
        minutes = Math.floor(storedTime / 60) % 60;
        hours = Math.floor(storedTime / 3600);
    }

    function propagateFromAbstractedTime() {
        storedTime = seconds + (minutes * 60) + (hours * 3600);
    }

    property bool timerRunning: countTimer.running

    function timerStart() {
        if (storedTime <= 0) {
            storedTime = storedTimeInitial
        }

        countTimer.start();
        isFieldFocusable = false;
    }

    function timerStop() {
        countTimer.stop();
        isFieldFocusable = true;
    }
}
