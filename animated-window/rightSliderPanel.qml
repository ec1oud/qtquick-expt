import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Window 2.0

Rectangle {
    id: root
    width: 640
    height: 480

    Rectangle {
        id: sliderPane
        width: 480
        height: root.height
        property real stickout: rect.radius * 2
        property int xOpen: root.width - stickout
        property int xClosed: root.width - sliderPane.width +stickout
        x: xClosed
        y: 2
        //    onXChanged: console.log("x " + x)

        MouseArea {
            anchors.fill: parent
            property real lastPaneX: 0
            property real lastMouseX: 0
            onPressed: {
                state = ""
                lastPaneX = sliderPane.x
                lastMouseX = mouseX
            }
            onMouseXChanged: sliderPane.x += (mouseX - lastMouseX)
            onReleased: {
                if (sliderPane.x - lastPaneX > 20)
                    state = "stateOpen"
                else if (sliderPane.x - lastPaneX < -20)
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
                        target: sliderPane
                        properties: "x"
                        to: sliderPane.xClosed
                        duration: 300
                        easing {type: Easing.OutBounce; overshoot: 5}
                    }
                },
                Transition {
                    to: "stateOpen"
                    NumberAnimation {
                        target: sliderPane
                        properties: "x"
                        to: sliderPane.xOpen
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
}
