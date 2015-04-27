import QtQuick 2.0

Item {
    id: root
    height: parent.height
    width: height
    property int octaveIndex: 0

    Repeater {
        id: repw
        property int keyCount: 7
        property real keyWidth: parent.width / repw.keyCount
        model: keyCount
        KeyWhite {
            x: modelData * repw.keyWidth
            y: 5
            z: repw.keyCount - modelData
            width: repw.keyWidth - 2
            height: parent.height - 30
            index: modelData
            octaveIndex: root.octaveIndex
        }
    }

    KeyBlack {
        x: repw.keyWidth - width * 2 / 3
        y: 5
        z: 10
        width: repw.keyWidth / 2
        height: parent.height / 2
        toneIndex: 4
        octaveIndex: root.octaveIndex
    }

    KeyBlack {
        x: repw.keyWidth * 2 - width * 1 / 3
        y: 5
        z: 10
        width: repw.keyWidth / 2
        height: parent.height / 2
        toneIndex: 6
        octaveIndex: root.octaveIndex
    }


    KeyBlack {
        x: repw.keyWidth * 4 - width * 2 / 3
        y: 5
        z: 10
        width: repw.keyWidth / 2
        height: parent.height / 2
        toneIndex: 9
        octaveIndex: root.octaveIndex
    }

    KeyBlack {
        x: repw.keyWidth * 5 - width * 1 / 2
        y: 5
        z: 10
        width: repw.keyWidth / 2
        height: parent.height / 2
        toneIndex: 11
        octaveIndex: root.octaveIndex
    }

    KeyBlack {
        x: repw.keyWidth * 6 - width * 1 / 3
        y: 5
        z: 10
        width: repw.keyWidth / 2
        height: parent.height / 2
        toneIndex: 13
        octaveIndex: root.octaveIndex
    }
}
