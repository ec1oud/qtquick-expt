import QtQuick 2.0

Item {
    width: 200; height: 200

    DropArea {
        x: 50; y: 50
        width: 150; height: 150

        Rectangle {
            anchors.fill: parent
            color: parent.containsDrag ? "green" : "beige"
        }
    }

    Rectangle {
        x: 10; y: 10
        width: 40; height: 40
        color: "red"

        Drag.active: dragArea.drag.active
        Drag.hotSpot.x: 10
        Drag.hotSpot.y: 10

        MouseArea {
            id: dragArea
            anchors.fill: parent

            drag.target: parent
        }
    }
}
