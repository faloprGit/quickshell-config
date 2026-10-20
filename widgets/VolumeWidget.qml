import QtQuick
import Quickshell.Services.SystemTray
import ".."

Item {
    implicitWidth: volumeRow.width
    implicitHeight: volumeRow.height

    Row {
        id: volumeRow
        spacing: Metrics.defaultRowSpacing
        anchors.centerIn: parent

        PillButton {
            anchors.verticalCenter: parent.verticalCenter
            text: AudioController.defaultAudioSink.audio.muted ? "󰝟" : "󰕾"

            onClicked: {
                AudioController.toggleMute()
            }
        }

        PillSlider {
            anchors.verticalCenter: parent.verticalCenter
            enableScroll: true
            scrollStep: 0.01
            value: AudioController.defaultAudioSink.audio.volume
            from: 0
            to: 1.5

            onMoved: {
                AudioController.setVolume(value)
            }
        }

        PillText {
            text: AudioController.volumePercent + "%"
            sampleText: "150%"
        }
    }
}
