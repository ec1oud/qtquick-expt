import QtQuick 2.0
import QtQuick.Window 2.0

Window {
	id: root
	width: image.implicitWidth
	height: image.implicitHeight + 50
	visible: true
//    property int yOpen: screen.availableVirtualSize.height - root.height
//    property int yClosed: screen.availableVirtualSize.height - 10
    property int yOpen: Screen.height - root.height
    property int yClosed: Screen.height - 10
	color: "transparent"
	flags: Qt.FramelessWindowHint
	Component.onCompleted: {
		root.x = (image.Screen.width - image.implicitWidth) / 2
        root.y = yClosed
	}

	Image {
        id: image
        source: "baloon.png"
        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: state = "stateOpen"
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
                        properties: "y"
                        to: root.yClosed
                        from: root.yOpen
                        duration: 1000
                        easing {type: Easing.OutBounce; overshoot: 5}
                   }
                },
                Transition {
                    from: "stateClosed"
                    to: "stateOpen"
                    NumberAnimation {
                        target: root
                        properties: "y"
                        from: root.yClosed
                        to: root.yOpen
                        duration: 1000
                        easing {type: Easing.OutBounce; overshoot: 5}
                   }
                }
            ]
        }
    }
}
