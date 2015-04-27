import QtQuick 2.0
import CustomGeometry 1.0

Rectangle {
    width: 300
    height: 200
    color: "black"

    BezierCurve {
        id: line
        anchors.fill: parent
        anchors.margins: 20
        property real t: 0.25

        p2: Qt.point(t, 1 - t)
        p3: Qt.point(1 - t, t)
    }
}
