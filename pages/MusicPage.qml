pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell.Services.Mpris
import ".."

Item {
    id: mainPage
    implicitWidth: mainColumn.implicitWidth
    implicitHeight: Metrics.musicPageHeight

    readonly property int coverRadius: 10
    readonly property MprisPlayer player: MusicController.currentChoice

    // Active position tick driver
    property real livePosition: player ? player.position : 0

    // Force instant update whenever the player selection changes
    onPlayerChanged: {
        livePosition = player ? player.position : 0;
    }

    Timer {
        id: positionTimer
        interval: 250
        running: mainPage.player && mainPage.player.playbackState === MprisPlaybackState.Playing && !progressSlider.pressed
        repeat: true
        onTriggered: {
            if (mainPage.player) {
                mainPage.livePosition = mainPage.player.position;
            }
        }
    }

    // Keep livePosition updated on seek or position events
    Connections {
        target: mainPage.player
        ignoreUnknownSignals: true
        function onPositionChanged() {
            if (mainPage.player && !progressSlider.pressed) {
                mainPage.livePosition = mainPage.player.position;
            }
        }
    }

    ColumnLayout {
        id: mainColumn
        anchors.centerIn: parent
        spacing: Metrics.defaultColumnSpacing

        // Top Row: Player Selection & Toggles
        RowLayout {
            id: topRow
            spacing: Metrics.defaultRowSpacing
            Layout.alignment: Qt.AlignHCenter

            // Paired Chevron Buttons
            RowLayout {
                spacing: 2
                PillButton {
                    text: ""
                    onClicked: MusicController.changeIndex(-1)
                }
                PillButton {
                    text: ""
                    onClicked: MusicController.changeIndex(1)
                }
            }

            PillText {
                text: mainPage.player ? MusicController.currentChoice.identity : "No Player"
                sampleText: "XXXXXXXXXXXXXX"
            }

            Item { Layout.preferredWidth: Metrics.defaultRowSpacing }

            PillButton {
                text: "󰒟"
                active: mainPage.player ? mainPage.player.shuffle : false
                onClicked: MusicController.toggleShuffle()
            }
            PillButton {
                text: mainPage.player && mainPage.player.loopState === MprisLoopState.Track ? "" : ""
                active: mainPage.player ? (mainPage.player.loopState !== MprisLoopState.None) : false
                onClicked: MusicController.cycleLoop()
            }
        }

        // Middle Row: Cover Art, Metadata, Controls & Vertical Volume
        RowLayout {
            id: middleRow
            spacing: Metrics.defaultRowSpacing

            // Cover Art
            Item {
                id: albumArtContainer
                Layout.preferredHeight: metadataColumn.implicitHeight > 0 ? metadataColumn.implicitHeight : 90
                Layout.preferredWidth: Layout.preferredHeight
                Layout.alignment: Qt.AlignVCenter

                Image {
                    id: albumArt
                    anchors.fill: parent
                    source: MusicController.currentChoice ? MusicController.currentChoice.trackArtUrl : ""
                    visible: false
                    fillMode: Image.PreserveAspectCrop
                    mipmap: true
                    smooth: true
                    antialiasing: true
                }

                MultiEffect {
                    anchors.fill: parent
                    source: albumArt
                    maskEnabled: true
                    maskThresholdMin: 0.5
                    maskSpreadAtMin: 1.0

                    maskSource: ShaderEffectSource {
                        sourceItem: Rectangle {
                            width: albumArtContainer.width
                            height: albumArtContainer.height
                            radius: mainPage.coverRadius
                            color: "black"
                        }
                    }
                }

                // Border overlay
                Rectangle {
                    anchors.fill: parent
                    radius: mainPage.coverRadius - 5
                    color: "transparent"
                    border.color: Colors.md3.secondary_container
                    border.width: 4
                }
            }

            ColumnLayout {
                id: metadataColumn
                spacing: Metrics.defaultColumnSpacing
                Layout.preferredWidth: 260

                ColumnLayout {
                    spacing: 2
                    Layout.fillWidth: true

                    PillText {
                        text: mainPage.player && mainPage.player.trackTitle !== "" ? mainPage.player.trackTitle : "Nothing Playing"
                        pixelSize: 18
                        Layout.fillWidth: true
                        scrollable: true
                    }

                    PillText {
                        text: {
                            if (!mainPage.player) return "No Media Active";

                            var artists = mainPage.player.trackArtists;
                            if (Array.isArray(artists) && artists.length > 0) {
                                return artists.join(", ");
                            } else if (typeof artists === "string" && artists.trim() !== "") {
                                return artists;
                            }

                            if (mainPage.player.trackAlbum && mainPage.player.trackAlbum !== "") {
                                return mainPage.player.trackAlbum;
                            }

                            return "Unknown Album / Artist";
                        }
                        pixelSize: 14
                        Layout.fillWidth: true
                        scrollable: true
                    }
                }

                RowLayout {
                    spacing: 4
                    Layout.alignment: Qt.AlignHCenter

                    PillButton {
                        text: ""
                        onClicked: MusicController.previousTrack()
                    }

                    PillButton {
                        text: ""
                        onClicked: MusicController.seek(-10)
                    }

                    PillButton {
                        text: (mainPage.player && mainPage.player.playbackState === MprisPlaybackState.Playing) ? "" : ""
                        onClicked: MusicController.togglePlayPause()
                    }

                    PillButton {
                        text: ""
                        onClicked: MusicController.seek(10)
                    }

                    PillButton {
                        text: ""
                        onClicked: MusicController.nextTrack()
                    }
                }
            }

            // Vertical Volume Control
            PillSlider {
                isVertical: true
                sliderLength: metadataColumn.implicitHeight > 0 ? metadataColumn.implicitHeight : 90
                Layout.alignment: Qt.AlignVCenter
                value: mainPage.player ? mainPage.player.volume : 0.0
                onMoved: {
                    if (mainPage.player) mainPage.player.volume = value;
                }
            }
        }

        // Bottom Row: Progress Track & Dynamic Time Label
        RowLayout {
            spacing: Metrics.defaultRowSpacing
            Layout.fillWidth: true

            PillSlider {
                id: progressSlider
                Layout.fillWidth: true

                readonly property real totalSeconds: (mainPage.player && mainPage.player.length > 0) ? mainPage.player.length : 0.0

                Binding on value {
                    when: !progressSlider.pressed && progressSlider.totalSeconds > 0
                    value: Math.min(1.0, Math.max(0.0, mainPage.livePosition / progressSlider.totalSeconds))
                }

                // Triggers strictly on mouse/touch release
                onReleased: {
                    if (mainPage.player && progressSlider.totalSeconds > 0) {
                        const targetTime = progressSlider.value * progressSlider.totalSeconds;
                        mainPage.player.position = targetTime;
                        mainPage.livePosition = targetTime;
                    }
                }
            }

            PillText {
                pixelSize: 12
                text: {
                    if (!mainPage.player) return "0:00 / 0:00";

                    // Use live slider preview while dragging, player's live position otherwise
                    var displaySeconds = progressSlider.pressed
                        ? (progressSlider.value * progressSlider.totalSeconds)
                        : mainPage.livePosition;

                    var curTotal = Math.max(0, Math.floor(displaySeconds));
                    var curM = Math.floor(curTotal / 60);
                    var curS = curTotal % 60;
                    var posStr = curM + ":" + (curS < 10 ? "0" : "") + curS;

                    // Track length in seconds
                    var totTotal = (mainPage.player.length > 0) ? Math.floor(mainPage.player.length) : 0;
                    var totM = Math.floor(totTotal / 60);
                    var totS = totTotal % 60;
                    var lenStr = totM + ":" + (totS < 10 ? "0" : "") + totS;

                    return posStr + " / " + lenStr;
                }
            }
        }
    }
}
