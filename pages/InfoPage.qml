import QtQuick
import QtQuick.Layouts
import ".."

Item {
    id: mainPage
    implicitWidth: rowLayout.implicitWidth
    implicitHeight: Metrics.infoPageHeight

    RowLayout {
        id: rowLayout
        anchors.centerIn: parent
        spacing: Metrics.defaultRowSpacing

        SystemInfoWidget {}

        //WeatherWidget {}
    }
}
