pragma Singleton
import QtQuick
import ".."

Item {
    component BouncySlide: NumberAnimation {
        duration: Metrics.animDurationSlow
        easing.type: Easing.BezierSpline

        easing.bezierCurve: [
            0.15, 0.60,
            0.25, 1.08,
            0.45, 1.08,

            0.65, 1.08,
            0.70, 1.00,
            1.00, 1.00
        ]
    }
}
