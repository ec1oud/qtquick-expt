import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Window 2.0

Window {
    id: root
    visible: true
    title: qsTr("drag & resize")
    flags: Qt.FramelessWindowHint
    color: "#80000022"
    width: rect.radius / 2
    height: 480
    x: -rect.radius
    y: 800
    property real maxWidth: 640
    onWidthChanged: console.log("width " + width)

    MouseArea {
        anchors.fill: parent
        property real lastMouseX: 0
        onPressed: {
            state = (state == "stateOpen" ? "stateClosing" : "stateOpening")
            lastMouseX = mouseX
        }
        onMouseXChanged: root.width = (state == "stateOpening" ?
            mouseX - lastMouseX + rect.radius * 2 : maxWidth + mouseX - lastMouseX)
        onReleased: {
            if (mouseX - lastMouseX > 20)
                state = "stateOpen"
            else if (mouseX - lastMouseX < -20)
                state = "stateClosed"
            root.x = -rect.radius
        }
        state: "stateClosed"
        //~ onStateChanged: console.log("state " + state)
        states: [
            State {
                name: "stateOpen"
            },
            State {
                name: "stateOpening"
            },
            State {
                name: "stateClosing"
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
                    properties: "width"
                    to: rect.radius * 2
                    duration: 300
                    easing {type: Easing.OutBounce; overshoot: 5}
                }
            },
            Transition {
                to: "stateOpen"
                NumberAnimation {
                    target: root
                    properties: "width"
                    to: root.maxWidth
                    duration: 300
                    easing {type: Easing.OutBounce; overshoot: 5}
                }
            }
        ]
    }

    Rectangle {
        id: rect
        anchors.fill: parent
        color: "transparent"
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
