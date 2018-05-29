import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Window 2.11
import Qt.labs.folderlistmodel 2.11
//import Qt.labs.handlers 1.0
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
            anchors.fill: parent
            property var lastUrls: []
            onDropped: {
                console.log("source " + drop.source + " dropped text:" + drop.text + " keys:" + drop.keys + " formats:" + drop.formats + " len " + drop.formats.length)
                if (drop.urls.length > 0)
                    console.log("dropped URLs " + drop.urls + " or " + JSON.stringify(drop.urls))
//                console.log("assuming formats is just one string: " + drop.formats + " = " + drop.getDataAsString(drop.formats))
//                var formatsArray = Object.assign({}, drop.formats) // doesn't work
//                console.log("formats as JS array " + formatsArray)
//                for (var fmt in drop.formats) // doesn't work: can't iterate QStringList with a for loop
//                    console.log("" + fmt, "=", drop.getDataAsString(fmt) + " or " + drop.getDataAsArrayBuffer(fmt))
                for (var i = 0; i < drop.formats.length; ++i) {
                    var fmt = drop.formats[i]
                    console.log(i + ": " + fmt + " = '", drop.getDataAsString(fmt) + "' or " + drop.getDataAsArrayBuffer(fmt))
                }
//                var urlsObj = Object.assign(lastUrls, drop.urls) // doesn't work
//                console.log("urls again " + lastUrls + " or " + JSON.stringify(lastUrls))
            }

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

                Drag.mimeData: { "text/plain" : folderModel.folder + fileName, "text/uri-list" : folderModel.folder + fileName }
                Drag.active: dragArea.drag.active
                Drag.dragType: Drag.Automatic
//                Drag.proposedAction: ? Qt.CopyAction : Qt.MoveAction : Qt.LinkAction // there's apparently no declarative way in MouseArea etc.

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
//                    Component.onCompleted: if (!fileIsDir) console.log("folder " + folderModel.folder + " file " + source)
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
                        drag.onActiveChanged: console.log("dragging " + JSON.stringify(fileFrame.Drag.mimeData) + " supported actions " + fileFrame.Drag.supportedActions + " proposed " + fileFrame.Drag.proposedAction)
                        onPressed: fileFrame.z = ++root.highestZ;
                        onEntered: fileFrame.state = "focused"
                        onExited: fileFrame.state = ""
                        onDoubleClicked: if (fileIsDir) folderModel.folder += fileName + "/"
                        onPositionChanged: {
                            if (mouse.modifiers & Qt.ControlModifier)
                                fileFrame.Drag.proposedAction = Qt.CopyAction
                            else if (mouse.modifiers & Qt.AltModifier)
                                fileFrame.Drag.proposedAction = Qt.LinkAction
                            else
                                fileFrame.Drag.proposedAction = Qt.MoveAction
                        }

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
