pragma ComponentBehavior: Bound
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


    // Monitor ALL connected media players dynamically (Spotify, Firefox, MPV, etc.)
    Instantiator {
        model: Mpris.players.values
        delegate: Connections {
            required property MprisPlayer modelData
            target: modelData
            ignoreUnknownSignals: true

            function onPlaybackStateChanged() {
                root.checkGlobalMusicState();
            }
        }

        onCountChanged: root.checkGlobalMusicState()
        onObjectAdded: root.checkGlobalMusicState()
        onObjectRemoved: root.checkGlobalMusicState()
    }

    function checkGlobalMusicState() {
        var anyPlaying = false;
        var players = Mpris.players.values;
        for (var i = 0; i < players.length; i++) {
            if (players[i].playbackState === MprisPlaybackState.Playing) {
                anyPlaying = true;
                selectedIndex = i;
                break;
            }
        }
        CompactController.notifyState("Music", anyPlaying, Config.compDefaultHangTime);
    }

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
