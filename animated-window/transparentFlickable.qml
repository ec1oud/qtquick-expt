import QtQuick 2.0
import QtQuick.Window 2.1

Window {
    visible: true
    width: 320
    height: 480
    x: 0
    color: "transparent"
//    flags: Qt.FramelessWindowHint | Qt.WindowTransparentForInput | Qt.CustomizeWindowHint
    flags: Qt.FramelessWindowHint
    Flickable {
        anchors.fill: parent
        contentWidth: 1200
        contentHeight: 1200
        rightMargin: -200
        Rectangle {
            width: 100
            height: 100
            x: 100
            y: 100
            radius: width / 5
            border.width: 4
            border.color: "white"
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#000000" }
                GradientStop { position: 0.2; color: "#888888" }
                GradientStop { position: 0.4; color: "#FFFFFF" }
                GradientStop { position: 0.6; color: "#FFFFFF" }
                GradientStop { position: 0.8; color: "#888888" }
                GradientStop { position: 1.0; color: "#000000" }
            }
        }
    }
}
