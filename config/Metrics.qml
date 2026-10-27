pragma Singleton
import QtQuick

QtObject {
    // Special Scaling Values
    property real commonObjectScaling: 7 / 10

    // Standardized Values
    property real defaultRadius: 26
    property real defaultRowSpacing: 8
    property real defaultColumnSpacing: 8
    property real defaultTextWeight: 700

    // Bar
    property real barHorizontalPadding: 32
    property real barVerticalPadding: 10

    // PillButton
    property real buttonWidth: buttonHeight
    property real buttonHeight: 50 * commonObjectScaling
    property real buttonRadius: Math.min((buttonHeight / 3), defaultRadius)

    // PillTextField
    property real textFieldWidth: textFieldHeight
    property real textFieldHeight: 50 * commonObjectScaling
    property real textFieldRadius: Math.min((textFieldHeight / 3), defaultRadius)

    // CalendarButton
    property real calendarButtonWidth: calendarButtonHeight
    property real calendarButtonHeight: 80 * commonObjectScaling

    // Widgets
    property real workspaceWidgetHeight: 50 * commonObjectScaling
    property real systemTrayIconSize: 45 * commonObjectScaling
    property real circleClockSize: 80

    // Pages settings
    property real pageRowSpacing: 25

    property real compactPageWidth: 150
    property real compactPageHeight: 30
    property real mainPageHeight: 60
    property real volumePageHeight: 60

    property real infoPageHeight: 180
    property real musicPageHeight: 220
    property real timePageHeight: 100
    property real catheterPageHeight: 120
    property real audioPageHeight: 100



    // Animations values
    property int animDurationFast: 100
    property int animDurationNormal: 250
    property int animDurationSlow: 450

    property int animEasingType: Easing.OutCubic
    property int animEasingQuad: Easing.InOutQuad
    property int animEasingSpring: Easing.OutBack
}
