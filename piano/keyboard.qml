import QtQuick 2.0
import "content"

Rectangle {
    width: 1024
    height: 500
    y: 0
    x: 0
    color: "darkgrey"
    property int octaveCount: 3

    Repeater {
        model: octaveCount
        Octave {
            x: width * modelData
            z: octaveCount - modelData
            width: height
            height: parent.height
            octaveIndex: modelData
        }
    }
}
