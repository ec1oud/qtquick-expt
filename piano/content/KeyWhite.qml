import QtQuick 2.0
import QtMultimedia 5.0

Item {
    id: root
    //~ property bool pressed: mpta.touchPoints.length > 0 // length is non-notifyable
    property bool pressed: mpta.pressed// || mouseArea.pressed
    property int index: 0
    property int octaveIndex: 0
    property int toneIndex: index < 3 ? index + index + 3 : index + index + 2
    Rectangle {
        transform: Rotation { origin.x: width / 2; origin.y: 0; axis { x: 1; y: 0; z: 0 } angle: pressed ? -7: 0 }
        antialiasing: true
        radius: width / 20
        border.color: "black"
        border.width: pressed ? 2 : 1
        width: parent.width
        height: pressed ? parent.height * (1 + 0.14 * parent.height / 1000.0)  : parent.height
        Rectangle {
            color: "#907B60"
            width: parent.width
            height: parent.height
            x: parent.width / -5
            y: 0
            z: -2
        }
        Rectangle {
            z: -1
            color: "tan"
            x: parent.width * 0.01
            width: parent.width * 0.98
            height: parent.width  / 10 + parent.radius
            y: parent.height - parent.radius
            border.color: "black"
        }
    }
    onPressedChanged: if (pressed) audio.play()
    Audio {
        id: audio
        source: "piano-a.wav"
        playbackRate: Math.pow(1.05946309436, root.toneIndex) * Math.pow(2, octaveIndex)
    }
    MultiPointTouchArea {
        id: mpta
        property bool pressed: false
        anchors.fill: parent
        minimumTouchPoints: 1
        maximumTouchPoints: 1
        onPressed: pressed = true
        onReleased: pressed = false
        onCanceled: pressed = false
    }
    Component.onCompleted: "index " + index + " playbackRate " + audio.playbackRate
}
