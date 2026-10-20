pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Services.Mpris
import ".."

Singleton {
    id: root

    property int selectedIndex: 0

    readonly property var activePlayers: Mpris.players.values
    readonly property MprisPlayer currentChoice: activePlayers.length > 0
        ? activePlayers[Math.min(selectedIndex, activePlayers.length - 1)]
        : null

    function changeIndex(value) {
        if (activePlayers.length > 0) {
            selectedIndex = (selectedIndex - value + activePlayers.length) % activePlayers.length;
        }
    }

    function togglePlayPause() {
        if (currentChoice && currentChoice.canControl) {
            currentChoice.togglePlaying();
        }
    }

    function toggleShuffle() {
        if (currentChoice && currentChoice.canControl) {
            currentChoice.shuffle = !currentChoice.shuffle;
        }
    }

    function cycleLoop() {
        if (!currentChoice || !currentChoice.canControl) return;

        if (currentChoice.loopState === MprisLoopState.None) {
            currentChoice.loopState = MprisLoopState.Playlist;
        } else if (currentChoice.loopState === MprisLoopState.Playlist) {
            currentChoice.loopState = MprisLoopState.Track;
        } else {
            currentChoice.loopState = MprisLoopState.None;
        }
    }

    function nextTrack() {
        if (currentChoice && currentChoice.canGoNext) currentChoice.next();
    }

    function previousTrack() {
        if (currentChoice && currentChoice.canGoPrevious) currentChoice.previous();
    }

    function seek(seconds) {
        if (currentChoice && currentChoice.canControl) {
            currentChoice.position = Math.max(0, Math.min(currentChoice.length, currentChoice.position + seconds));
        }
    }
}
