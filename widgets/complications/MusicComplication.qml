import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Mpris
import "../.."

Item {
    id: root

    implicitWidth: rowLayout.implicitWidth + 8
    implicitHeight: Metrics.compactPageHeight

    readonly property MprisPlayer player: MusicController.currentChoice
    readonly property bool isPlaying: player && player.playbackState === MprisPlaybackState.Playing

    RowLayout {
        id: rowLayout
        anchors.centerIn: parent
        spacing: 12

        PillText {
            pixelSize: 16
            color: Colors.md3.on_tertiary_container
            text: root.isPlaying ? "" : ""
            Layout.alignment: Qt.AlignVCenter
        }

        PillText {
            pixelSize: 16
            color: Colors.md3.on_tertiary_container
            text: root.player && root.player.trackTitle !== "" ? root.player.trackTitle : "Music"
            sampleText: "XXXXXXXXXXXXXX"
            sampleTextMinSize: true
            scrollable: true
            Layout.alignment: Qt.AlignVCenter
        }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Config.cursorOnMouseArea
        onClicked: PillController.navigateAndExpand("Music")
    }
}
