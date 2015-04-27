import QtQuick 2.0
import QtQuick.Window 2.1

Window {
    id: root
    visible: true
    width: 200
    height: 200
    y: 40
    property int xOpen: Screen.desktopAvailableWidth - 10
    property int xClosed: Screen.desktopAvailableWidth - root.width + rect.radius
    color: "transparent"
//    opacity: 1.0
    flags: Qt.FramelessWindowHint
    Component.onCompleted: {
        root.x = xOpen
        root.y = 40
    }

    Rectangle {
        id: rect
        anchors.fill: parent
        radius: 40
        border.color: "white"
        border.width: 3
        color: "#D0444422"
        antialiasing: true
        Rectangle {
            anchors.fill: parent
            anchors.margins: 1
            border.color: "black"
            border.width: 2
            antialiasing: true
            color: "transparent"
            radius: parent.radius
        }
        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: { console.log("onEntered"); state = "stateOpen" }
            onExited: state = "stateClosed"
            onClicked: state = "stateOpen"
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
                    from: "stateOpen"
                    to: "stateClosed"
                    NumberAnimation {
                        target: root
                        properties: "x"
                        to: root.xOpen
                        from: root.xClosed
                        duration: 1000
                        easing {type: Easing.OutBounce; overshoot: 5}
                    }
                },
                Transition {
                    from: "stateClosed"
                    to: "stateOpen"
                    NumberAnimation {
                        target: root
                        properties: "x"
                        from: root.xOpen
                        to: root.xClosed
                        duration: 1000
                        easing {type: Easing.OutBounce; overshoot: 5}
                    }
                }
            ]
        }

    }

}
