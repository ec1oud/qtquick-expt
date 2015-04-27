import QtQuick 2.1
import QtQuick.Window 2.0

Window {
    id: window
    visible: true
    width: 100
    height: 100
    flags: Qt.FramelessWindowHint

    Rectangle {
        color: "steelblue"
        anchors.top: parent.top
        width: parent.width
        height: 20
        MouseArea {
            anchors.fill: parent
            property real lastMouseX: 0
            property real lastMouseY: 0
            onPressed: {
                lastMouseX = mouseX
                lastMouseY = mouseY
            }
            onMouseXChanged: window.x += (mouseX - lastMouseX)
            onMouseYChanged: window.y += (mouseY - lastMouseY)
        }
    }
}
