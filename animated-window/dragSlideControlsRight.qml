import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Window 2.0

Window {
    id: root
    visible: true
    title: qsTr("drag & slide")
    flags: Qt.FramelessWindowHint
    color: "transparent"
    width: 640
    height: 480
    property real stickout: rect.radius * 2
    property int xOpen: Screen.desktopAvailableWidth - stickout
    property int xClosed: Screen.desktopAvailableWidth - root.width +stickout
    x: xClosed
    y: 800
//    onXChanged: console.log("x " + x)

    MouseArea {
        anchors.fill: parent
        property real lastWinX: 0
        property real lastMouseX: 0
        onPressed: {
            state = ""
            lastWinX = root.x
            lastMouseX = mouseX
        }
        onMouseXChanged: root.x += (mouseX - lastMouseX)
        onReleased: {
            if (root.x - lastWinX > 20)
                state = "stateOpen"
            else if (root.x - lastWinX < -20)
                state = "stateClosed"
        }
        state: "stateClosed"
        //~ onStateChanged: console.log("state " + state)
        states: [
            State {
                name: "stateOpen"
            },
            State {
                name: "stateClosed"
            }
        ]
        transitions: [
            Transition {
                to: "stateClosed"
                NumberAnimation {
                    target: root
                    properties: "x"
                    to: root.xClosed
                    duration: 300
                    easing {type: Easing.OutBounce; overshoot: 5}
                }
            },
            Transition {
                to: "stateOpen"
                NumberAnimation {
                    target: root
                    properties: "x"
                    to: root.xOpen
                    duration: 300
                    easing {type: Easing.OutBounce; overshoot: 5}
                }
            }
        ]
    }

    Rectangle {
        id: rect
        anchors.fill: parent
        color: "#80000022"
        border.color: "lightgrey"
        border.width: 4
        radius: 10
        antialiasing: true
    }

    Button {
        x: 488
        y: 404
        text: qsTr("Hello World")
        anchors.verticalCenterOffset: 180
        anchors.horizontalCenterOffset: 226
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
    }

    Slider {
        id: sliderHorizontal1
        x: 53
        y: 59
        width: 294
        height: 100
    }

    Slider {
        id: sliderVertical1
        x: 395
        y: 67
        orientation: 0
    }
}
