pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Pipewire
import ".."

Singleton {
    id: root

    readonly property var defaultAudioSink: Pipewire.defaultAudioSink

    readonly property real volume: defaultAudioSink?.audio?.volume ?? 0
    readonly property bool isMuted: defaultAudioSink?.audio?.muted ?? false
    readonly property int volumePercent: Math.round(volume * 100)

    readonly property var audioPages: ["Volume", "Audio"]

    PwObjectTracker {
        objects: Pipewire.defaultAudioSink ? [Pipewire.defaultAudioSink] : []
    }

    onVolumePercentChanged: {
        root.openVolumeOverlay();
    }

    onIsMutedChanged: {
        root.openVolumeOverlay();
    }

    function openVolumeOverlay() {
        if (!root.audioPages.includes(PillController.currentPageName) || OverlayController.isOverlayActive) {
            OverlayController.triggerOverlay("Volume");
        }
    }

    function setVolume(newVolume) {
        if (defaultAudioSink?.audio) {
            defaultAudioSink.audio.volume = Math.max(0.0, Math.min(1.5, newVolume));
        }
    }

    function toggleMute() {
        if (defaultAudioSink?.audio) {
            defaultAudioSink.audio.muted = !defaultAudioSink.audio.muted;
        }
    }
}
