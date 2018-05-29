import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Dialogs 1.1
import QtQuick.Window 2.1
import Qt.labs.folderlistmodel 1.0
//import "../../shared"

Window {
    id: root
    visible: true
    width: 1024; height: 600
    color: "#222222"
    property int highestZ: 0
    property real defaultSize: 64
    property real defaultSpacing: 8
    property real defaultLabelHeight: 20
    property real defaultTileGrid: defaultSize + defaultSpacing

    Rectangle {
        id: toolbar
        width: root.width
        height: currentFolderField.height + 6
        z: 1
        TextField {
            id: currentFolderField
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.margins: 3
            text: folderModel.folder
            DropArea {
                anchors.fill: parent
                onDropped: {
                    if (drop.urls.length > 0)
                        folderModel.folder = drop.urls[0] + "/"
                    else
                        currentFolderField.text = drop.text
                }
            }
        }
    }

    Item {
        id: iconArea
        anchors.fill: parent
        anchors.topMargin: toolbar.height

        DropArea {
            id: dragTarget

            property string colorKey
            //    property alias dropProxy: dragTarget

            anchors.fill: parent

            onDropped: {
                if (drop.urls.length > 0)
                    console.log("dropped URLs " + drop.urls)
                else
                    console.log(drop.source + " dropped " + drop.keys)
                for (var prop in Drag.mimeData) {
                    console.log("Object item:", prop, "=", anObject[prop])
                }
            }
            //    keys: [ colorKey ]

            states: [
                State {
                    when: dragTarget.containsDrag
                    PropertyChanges {
                        target: root
                        color: "grey"
                    }
                }
            ]
        }

        Repeater {
            model: FolderListModel {
                id: folderModel
                objectName: "folderModel"
                folder: "file:///home/rutledge/art/"
                nameFilters: ["*.png", "*.jpg", "*.gif"]
            }
            Rectangle {
                id: fileFrame
                color: "transparent"
                width: defaultSize
                height: width + defaultLabelHeight
                border.color: root.color
                border.width: 2

                Component.onCompleted: {
                    x = (index * defaultTileGrid) % (Math.floor(root.width / defaultTileGrid) * defaultTileGrid)
                    y = Math.floor((index * defaultTileGrid) / root.width) * (defaultTileGrid + defaultLabelHeight)
                }

                states: [
                    State {
                        name: "focused"
                        PropertyChanges { target: fileFrame; border.color: "red" }
                    }
                ]
                Image {
                    id: image
                    anchors.centerIn: parent
                    anchors.verticalCenterOffset: (defaultLabelHeight / -2) + 1
                    fillMode: Image.PreserveAspectFit
                    source: fileIsDir ? "resources/folder.png" : folderModel.folder + fileName
                    scale: defaultSize / Math.max(sourceSize.width, sourceSize.height)
                    antialiasing: true
                }
                Text {
                    color: "white"
                    anchors {
                        left: parent.left
                        right: parent.right
                        bottom: parent.bottom
                    }
                    style: Text.Outline
                    text: fileName
                    wrapMode: Text.Wrap
                    horizontalAlignment: Text.AlignHCenter
                    font.pointSize: 6
                }

                PinchArea {
                    anchors.fill: parent
                    pinch.target: fileFrame
                    pinch.minimumRotation: -360
                    pinch.maximumRotation: 360
                    pinch.minimumScale: 0.1
                    pinch.maximumScale: 10
                    onPinchFinished: fileFrame.border.color = "black";
                    MouseArea {
                        id: dragArea
                        hoverEnabled: true
                        anchors.fill: parent
                        drag.target: fileFrame
                        onPressed: fileFrame.z = ++root.highestZ;
                        onEntered: fileFrame.state = "focused"
                        onExited: fileFrame.state = ""
                        onPositionChanged: if (pressed) {
                            console.log("fileFrame x " + fileFrame.x)
                            if (fileFrame.x < 0 || fileFrame.x > root.width) {
                                Drag.active = true;
                                Drag.mimeData = { "text/plain" : fileName }
                                console.log("startExternal " + Drag.mimeData);
                                Drag.startExternal();
                            }
                        }

                        onDoubleClicked: if (fileIsDir) folderModel.folder += fileName + "/"
                        onWheel: {
                            if (wheel.modifiers & Qt.ControlModifier) {
                                fileFrame.rotation += wheel.angleDelta.y / 120 * 5;
                                if (Math.abs(fileFrame.rotation) < 4)
                                    fileFrame.rotation = 0;
                            } else {
                                fileFrame.rotation += wheel.angleDelta.x / 120;
                                if (Math.abs(fileFrame.rotation) < 0.6)
                                    fileFrame.rotation = 0;
                                var scaleBefore = image.scale;
                                image.scale += image.scale * wheel.angleDelta.y / 120 / 10;
                                fileFrame.x -= image.width * (image.scale - scaleBefore) / 2.0;
                                fileFrame.y -= image.height * (image.scale - scaleBefore) / 2.0;
                            }
                        }
                    }
                }
            }
        }
    }

}
