import QtQuick 2.0
import QtMultimedia 5.0

Item {
    id: root
    property bool pressed: mpta.pressed || mouseArea.pressed
    property int octaveIndex: 0
    property int toneIndex: 0
    Rectangle {
        color: "black"
        transform: Rotation { origin.x: width / 2; origin.y: 0; axis { x: 1; y: 0; z: 0 } angle: pressed ? -12: 0 }
        antialiasing: true
        radius: width / 20
        width: parent.width
        height: pressed ? parent.height * (1 + 0.14 * parent.height / 1000.0)  : parent.height
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
