import QtQuick
import ".."

Item {

    implicitWidth: mainColumn.implicitWidth
    implicitHeight: mainColumn.implicitHeight

    Column {
        id: mainColumn
        anchors.fill: parent

        spacing: Metrics.defaultColumnSpacing

        Row {
            PillTextField {
                text: TimingController.hours
                isFocusable: TimingController.isFieldFocusable

                onTextEdited: {
                    TimingController.hours = text;
                    TimingController.propagateFromAbstractedTime();
                }
            }

            PillText {
                text: ":"
            }

            PillTextField {
                text: TimingController.minutes
                isFocusable: TimingController.isFieldFocusable

                onTextEdited: {
                    TimingController.minutes = text;
                    TimingController.propagateFromAbstractedTime();
                }
            }

            PillText {
                text: ":"
            }

            PillTextField {
                text: TimingController.seconds
                isFocusable: TimingController.isFieldFocusable

                onTextEdited: {
                    TimingController.seconds = text;
                    TimingController.propagateFromAbstractedTime();
                }
            }
        }

        Row {
            spacing: Metrics.defaultRowSpacing
            PillButton {
                implicitWidth: mainColumn.width * 0.70 - Metrics.defaultRowSpacing
                text: TimingController.timerRunning ? "Stop" : "Start"
                onClicked: TimingController.timerRunning ? TimingController.timerStop() : TimingController.timerStart()
            }

            PillButton {
                implicitWidth: mainColumn.width * 0.30
                text: TimingController.isCountingDown ? "" : ""
                onClicked: TimingController.isCountingDown = !TimingController.isCountingDown
            }
        }
    }
}
