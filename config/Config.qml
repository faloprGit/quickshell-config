pragma Singleton
import QtQuick

QtObject {
    readonly property string username: "snowman"
    readonly property bool showOnAllScreens: false
    readonly property var cursorOnMouseArea: Qt.PointingHandCursor // or default: Qt.ArrowCursor
    readonly property int volumeStepSize: 5

    readonly property string location: "Meise" // For weather
    readonly property bool useFahrenheit: false
}
